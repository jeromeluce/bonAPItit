class Api::V1::MembersController < ActionController::API
    before_action :set_member, only: [:show]
    def show
    end

    def create
        @member = Member.new(member_params)
        @member.group = Group.where(registration_code: params[:registration_code]).first
        if @member.save
            render :show, status: :created
        else
            render_error
        end
    end

    private

    def set_member
        @member = Member.find(params[:id])
    end

    def member_params
        params.require(:member).permit(:name, :allergies, :registration_code)
    end

    def render_error
        render json: { errors: @member.errors.full_messages },
          status: :unprocessable_entity
      end
end