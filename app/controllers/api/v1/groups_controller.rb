class Api::V1::GroupsController < ActionController::API
    before_action :set_group, only: [:show]
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
end