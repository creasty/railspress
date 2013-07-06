class Setting < ActiveRecord::Base

  attr_accessible :params

  #  Association
  #-----------------------------------------------
  belongs_to :setting_option
  belongs_to :user

  #  Public Methods
  #-----------------------------------------------
  def read
    unless @op
      @op = params.present? ? ActiveSupport::JSON.decode(params) : {}
      @op.symbolize_keys!
      @op[:_name] = notification_topic.name
    end

    @op
  end
  def write(params)
    read.merge! params
    params = ActiveSupport::JSON.encode read
  end

end
