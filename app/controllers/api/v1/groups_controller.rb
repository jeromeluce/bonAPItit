class Api::V1::GroupsController < ActionController::API
    before_action :set_group, only: [:show, :restaurants_list, :owner_restaurants_list]
    def show
    end

    def create
        @group = Group.new(group_params)
        if @group.save
            BuildGroupRestaurantsList.perform_later @group
            render :show, status: :created
        else
            render_error
        end
    end

    def restaurants_list
        if params["group"]["registration_code"] == @group.registration_code
            @restaurants = @group.restaurants.order(google_rating: :desc)
            render :restaurants_list
        else
            render_unauthorized
        end
    end

    def owner_restaurants_list
        if params["group"]["admin_code"] == @group.admin_code
            @restaurants = @group.restaurants.order(Arel.sql('google_rating + cached_weighted_score DESC'))
            render :owner_restaurants_list
        else
            render_unauthorized
        end
    end

    private

    def set_group
        @group = Group.find(params[:id])
    end

    def group_params
        params.require(:group).permit(:name, :address, :radius)
    end

    def render_error
        render json: { errors: @group.errors.full_messages },
          status: :unprocessable_entity
    end

    def render_unauthorized
        render json: { errors: "You are not allowed to use this resource" },
          status: "401"
    end
end