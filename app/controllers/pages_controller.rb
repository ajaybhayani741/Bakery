class PagesController < ApplicationController
  def home
  end

  def process_order
    vs = params[:vegemite_scroll]
    bm = params[:blueberry_muffin]
    cf = params[:croissant]
    if vs.present?
      vegemite_scroll = get_rules('VS5', vs.to_i)
    end
    if bm.present?
      blueberry_muffin = get_rules('MB11', bm.to_i)
    end
    if cf.present?
      croissant = get_rules('CF', cf.to_i)
    end

    render json: { 'success': true, 'vegemite_scroll': vegemite_scroll, 'blueberry_muffin': blueberry_muffin, 'croissant': croissant }
  end

  private
    def get_rules(code,total_number)
      arr = [ {
          code: 'VS5',
          packs: [ {count: 3, cost: 6.99},
                    {count: 5, cost: 8.99} ]
        },
        {
          code: 'MB11',
          packs: [ { count: 2, cost: 9.95 },
            { count: 5, cost: 16.95 },
            { count: 8, cost: 24.95 } ]
        },
        {
          code: 'CF',
          packs: [ { count: 3, cost: 5.95 },
            { count: 5, cost: 9.95 },
            { count: 9, cost: 16.99 } ]
        },
      ]

      packs = arr.find {|item| item[:code] == code }[:packs].sort_by{|e| -e[:count]}

      total = 0 
      final_items = []
      packs.each do |item| 
        final_items = []
        current_count = item[:count] 

        if (total_number % current_count == 0) 
          (total_number / current_count).times { final_items << item }

          total = total_number
          break 
        elsif 
          return_int = total_number / current_count

          return_int.times do |i| 
            final_items = []

            total = current_count * (return_int-i)
            (return_int-i).times { final_items << item }

            packs.each do |pack| 
              next if pack == item 

              tt = 1 
              loop do 
              if total >= total_number 
                if total == total_number
                  break
                else
                  total = total - (pack[:count]) if tt > 1
                end
                break 
              else 
                total += pack[:count]   
                final_items << pack if total <= total_number 
                tt += 1 
              end 
              end 
              break if total == total_number
            end 

            break if total == total_number

          end 

        end 

        break if total == total_number

      end
      sum = final_items.sum { |a| a[:cost] }.round(2)
      final_items = final_items.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }

      final_result = {}
      final_result['items'] =  final_items.map{|a,b| {key: a,value: b}}.to_json
      final_result['sum'] = sum

      final_result
    end
end
