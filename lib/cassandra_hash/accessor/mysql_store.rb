require 'mysqlplus'
class Mysql
  def closed?
    !ping()
  end
  
  alias :query :async_query
end

module CassandraHash
  module Accessor
    class MysqlStore < Abstract
      attr_accessor :serializer
      def initialize(*args)
        @connection_pool = Pandemic::ConnectionPool.new
        @connection_pool.create_connection{ Mysql.connect(*args) }
      end

      def get(klass, keys)
        name = klass.column_family_name
        case keys
        when Array
          keys = keys.map{|key|keys.to_s}
          values = {}
          @connection_pool.with_connection do |c|
            st = c.prepare("select id, data from #{klass.column_family_name} where id in (?)") 
            st.execute(keys.join(","))
            st.each do |row|
              values[row[0]] = Marshal.load(row[1])
            end
            st.close
          end
          values
        else
          value = nil
          encoded_attributes = @connection_pool.with_connection do |c| 
            st = c.prepare("select id, data from #{klass.column_family_name} where id =?") 
            st.execute(keys)
            fetch_row = st.fetch
            value = Marshal.load(fetch_row[1]) unless fetch_row.nil?
            st.close
          end
          (value || {})
        end        
      end
  
      # Set saves takes the class name of an object and its key; 
      #      and returns the attributes
  
      # @param [String], [String], [Hash]
      # @return [Hash]
      def set(klass, key, attributes)
        name = klass.column_family_name
        data = Marshal.dump(attributes)
        @connection_pool.with_connection do |c| 
          st = c.prepare("insert into #{name} (id, data) values (?, ?) on duplicate key update data = ?")
          st.execute(key, data, data)
          st.close
        end
      end
      
      def delete(klass, key)
        @connection_pool.with_connection do |c| 
          st = c.preapre("delete from #{klass.column_family_name} where id = ?")
          st.execute(key)
          st.close
        end
      end
    end
  end
end