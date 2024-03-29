module Pagination
    extend ActiveSupport::Concern
    
    ##
    # > It takes in a collection of data, paginates it using the `pagy` gem, and returns the paginated
    # data along with the meta data required for pagination
    # 
    # Args:
    #   data: The data that you want to paginate.
    # 
    # Returns:
    #   The records and the options hash.
    def paginate(data)
        pagy, records = pagy(data, page: pagination_params[:page], items: pagination_params[:size])
        
        options = get_meta_data(pagy).to_h
        
        return records, options
    end
    
    def pagination_params
        params.permit(:page, :size)
    end
    
    def get_meta_data(paginated)
       pagy_meta = pagy_metadata(paginated)
       
       meta_data = {
           meta: {
               total_items: pagy_meta[:count],
               current_page: pagy_meta[:page],
               page_items: pagy_meta[:items]
           },
           links: get_links(pagy_meta)
       }
       
       meta_data
    end
    
    def get_links(meta_data)
        url = get_base_url
        
        links = {
            first: "#{url}#{meta_data[:first_url]}",
            prev: "#{url}#{meta_data[:prev_url]}",
            current: "#{url}#{meta_data[:page_url]}",
            next: "#{url}#{meta_data[:next_url]}",
            last: "#{url}#{meta_data[:last_url]}"
        }

        links
    end
    
    def get_base_url
        request.base_url
    end
end