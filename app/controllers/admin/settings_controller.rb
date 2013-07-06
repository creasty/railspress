
class Admin::SettingsController < Admin::ApplicationController

  def index
    @settings = User.current_user.settings
  end

  def update
    respond_to do |format|
      format.json do
        @setting = User.current_user.settings.find params[:id]

        if @setting.update_attributes params[:setting]
          render json: @setting.to_json
        else
          render json: @setting.errors.full_messages,
            status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @setting = User.current_user.settings.find params[:id]
    @setting.destroy

    respond_to do |format|
      format.json do
        render json: {}
      end
    end
  end

end
