module Extension
  module DataTable

    extend ActiveSupport::Concern

    module ClassMethods

      def to_datatable(controller, options = {}, &block)
        Proxy.new self, controller, options, &block
      end

    end

    class Proxy

      def initialize(klass, controller, options = {}, &block)
        @klass      = klass
        @controller = controller
        @params     = controller.params.dup.symbolize_keys
        @scoped     = klass.scoped
        @options    = options
        @fields     = @params.dup.select { |k,v| k.to_s =~ /mDataProp_\d+/ }.inject({}) do |h, (k, v)|
          (@scoped.joins_values | @scoped.includes_values).each do |join|
            v = v.gsub(join.to_s, join.to_s.camelize.constantize.table_name)
            v = v.split('.').map do |l|
              v.include?('.') ? "#{l}" : "#{@klass.table_name}.#{l}"
            end.join('.')
          end
          h[k.to_s.match(/(\d+)/)[0]] = v
          h
        end
      end

      def records
        conditions.limit(page_size).offset(current_page)
      end

      def s_echo
        @params[:sEcho].to_i
      end

      def total_records
        @scoped.count
      end

      def display_total_records
        conditions.count
      end

      private

      def conditions
        @scoped.order(order_by_conditions).where(filter_conditions).where(filter_field_conditions)
      end

      # 排序
      def order_by_conditions
        order_params = @params.dup.select { |k, v| k.to_s =~ /(i|s)Sort(Col|Dir)_\d+/ }
        return '' if order_params.blank?
        order_sql = []
        order_params.select { |k, v| k.to_s =~ /iSortCol_\d+/ }.map do |k, v|
          i = /iSortCol_(\d+)/.match(k.to_s)[1]
          order_sql << "#{@fields[v]} #{order_params[:"sSortDir_#{i}"]}"
        end
        order_sql.join(' ,')
      end

      def filter_conditions
        filter_fields = @fields.select { |k, v| v.to_s !~ /.*(_at|html|_xml|_json)/ }
        return '' if @params[:sSearch].blank?
        filter_sql = []
        filter_fields.each do |k, v|
          field = v.include?('.') ? v : "#{@klass.table_name}.#{v}"
          filter_sql << "#{field} like '%#{@params[:sSearch].gsub(/\'/, "")}%'"
        end
        filter_sql.join(' or ')
      end

      def filter_field_conditions
        filter_fields = @fields.select { |k, v| v.to_s !~ /.*(_at|html|_xml|_json)/ }
        filter_sql = []
        @params.dup.select { |k,v| k.to_s =~ /sSearch_\d+/ }.map do |k, v|
          next if v.blank?
          filter_sql << "#{filter_fields[k.to_s.match(/\d+/)[0].to_s]} like '%#{v.gsub(/\'/, "")}%'"
        end
        filter_sql.join(' and ')
      end

      def current_page
        @params[:iDisplayStart].to_i
      end

      def page_size
        @params[:iDisplayLength].to_i
      end

    end
  end
end