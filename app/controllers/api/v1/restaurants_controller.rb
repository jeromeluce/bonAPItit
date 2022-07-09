class Api::V1::RestaurantsController < ActionController::API
    before_action :set_member, :set_restaurant

    def upvote_restaurant
        @restaurant.liked_by @member
        if @restaurant.vote_registered?
            render :upvote_success
        else
            render :upvote_failure
        end
    end

    def downvote_restaurant
        @restaurant.disliked_by @member
        if @restaurant.vote_registered?
            render :downvote_success
        else
            render :downvote_failure
        end
    end

    private

    def set_member
        @member = Member.where(member_code: params[:member_code])&.first
    end

    def set_restaurant
        @restaurant = Restaurant.where(id: params[:id]).where(group_id: @member.group.id)&.first
    end
    def render_error
        render json: { errors: @member.errors.full_messages },
          status: :unprocessable_entity
    end
end