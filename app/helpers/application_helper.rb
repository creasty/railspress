module ApplicationHelper

  #  Page Title
  #-----------------------------------------------
  def page_title(cn = nil, ac = nil, ns = nil)
    title_form_hash page_title_hash(cn, ac, ns)
  end

  def document_title(cn = nil, ac = nil, ns = nil)
    title_form_hash page_title_hash(cn, ac, ns), :document
  end

  def page_title_hash(
    cn = controller_name,
    ac = action_name,
    ns = get_namespace
  )
    cn ||= controller_name
    ac ||= action_name
    ns ||= get_namespace

    serialized = [ns, cn, ac].join '.'

    @page_title_hash ||= {}
    return @page_title_hash[serialized] unless @page_title_hash.try(:[], serialized).nil?

    auto = {}

    s = I18n.t ['title', ns, cn.singularize].join('.'), default: ''
    p = I18n.t ['title', ns, cn.pluralize].join('.'), default: ''

    case ac
      when 'index'
        auto[:main] =
          if s.empty?
            nil
          elsif p.empty?
            sprintf(I18n.t('title._index', default: '%s'), s)
          else
            p
          end
      when 'show'
        auto[:depth] = s
      when 'new', 'create'
        auto[:main] = sprintf I18n.t('title._new'), s
        auto[:depth] = s
      when 'edit', 'update'
        auto[:main] = sprintf I18n.t('title._edit'), s
        auto[:depth] = s
    end

    hash = (cn == controller_name) ? get_page_title : {}
    hash.merge! auto
    hash[:site] = I18n.t ['title', ns, '_site'].join('.')

    @page_title_hash[serialized] = hash
  end

  private


  def get_page_title
    name = '@' + controller_name.singularize
    t = self.controller.instance_variable_get name

    if !t.nil? && (t[:title] || t[:name])
      { main: t[:title] || t[:name] }
    else
      self.controller.instance_variable_get(:@page_title) || {}
    end
  end

  def title_form_hash(hash, style = :page)
    # prefix     main      sub    depth      site       after
    # Aaaaaaaaa: Bbbbbbbbb - Cccc | Dddddddd | Eeeeeeee * Fffffff

    title = []

    unless hash[:prefix].nil?
      title << hash[:prefix] + ':'
    end

    unless hash[:main].nil?
      title << hash[:main]
    end

    unless hash[:sub].nil?
      title << ['-', hash[:sub]]
    end

    if :page == style
      if hash[:depth].nil?
        title << '|' unless hash[:main].nil? && hash[:sub].nil?
      else
        if hash[:depth].instance_of? Array
          hash[:depth] = hash[:depth].join ' | '
        end

        title << ['|', hash[:depth], '|']
      end

      unless hash[:site].nil?
        title << hash[:site]
      end

      unless hash[:after].nil?
        title << [8226.chr, hash[:after]]
      end
    end

    title.join ' '
  end

  #  Avatar
  #-----------------------------------------------
  def avatar_url(user, size = 48)
    gravatar_id = Digest::MD5.hexdigest user.email.downcase

    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

end
