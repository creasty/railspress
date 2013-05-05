class String

  def to_slug(param)
    ret = param.strip.downcase

    ret.gsub! /['`]/, ''

    ret.gsub! /\s*@\s*/, ' at '
    ret.gsub! /\s*&\s*/, ' and '
    ret.gsub! /\s*%\s*/, ' percent '

    ret.gsub! /\s*[^a-z0-9]\s*/, '-'
    ret.gsub! /[-_]+/, '-'
    ret.gsub! /\A[-\.]+|[-\.]+\z/, ''

    ret
  end

end