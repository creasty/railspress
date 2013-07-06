
class Setting < ActiveRecord::Base

  attr_accessible :params, :user_id, :setting_option_id

  #  Association
  #-----------------------------------------------
  belongs_to :setting_option
  belongs_to :user
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :setting_option

  #  Public Methods
  #-----------------------------------------------
  def read
    unless @op
      @op = params.present? ? ActiveSupport::JSON.decode(params) : {}
      @op.symbolize_keys!
      @op[:_name] = setting_option.name
    end

    @op
  end

  def write(params = {}, merge = true)
    params = read.merge params if merge
    params.except! :_name
    self.params = ActiveSupport::JSON.encode params
    self
  end

end
