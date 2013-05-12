# encoding: utf-8

module PagesCore::FrontendHelper
  def root_pages
    @root_pages ||= Page.roots.localized(@locale).published
  end

  def root_page
    @root_page ||= root_pages.first
  end

  def formatted_date(date, options={})
    date = date.to_date
    options.symbolize_keys!

    # TODO: Internationalize
    return "Today" if date == Date.today
    return "Yesterday" if date == Time.now.yesterday.to_date

    options[:include_day] ||= false
    options[:short_month], options[:short_day] = true if options[:short]
    if @locale.to_s == 'nor'
      months = ( !options[:short_month] ) ? %w{januar februar mars april mai juni juli august september oktober november desember} : %w{jan feb mar apr mai jun jul aug sep okt nov des}
      days   = ( !options[:short_day] )   ? %w{søndag mandag tirsdag onsdag torsdag fredag lørdag} : %w{søn man tir ons tor fre lør}
    else
      months = ( !options[:short_month] ) ? %w{January February March April May June July August September October November December} : %w{Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec}
      days   = ( !options[:short_day] )   ? %w{Sunday Monday Tuesday Wednesday Thursday Friday Saturday} : %w{Sun Mon Tue Wed Thu Fri Sat}
    end
    days   = days.map{ |d| d.downcase } unless options[:capitalize_day]

    output  = ""
    output += days[(date.strftime( "%w" ).to_i)]+" " if options[:include_day]
    output += "#{date.day}. " + months[(date.strftime("%m").to_i-1)]
    output += date.strftime( " %Y" ) if date.strftime( "%Y" ) != Time.now.strftime( "%Y" ) || options[:include_year]
    output
  end

  def formatted_time(time, options={})
    f = formatted_date(time, options)
    #f += time.strftime( " %Y" ) if time.strftime("%Y") != Time.now.strftime("%Y")
    f
  end

  def nav_link(page)
    link_to page.name.to_s, page_url(page) #:controller => :pages, :action => :show, :id => page
  end

  def nav_list_item(page, options={})
      options[:selected_class] ||= 'selected'
        if page.redirects? && page.redirect_to_options.kind_of?(Hash) && page.redirect_to_options[:controller] == params[:controller]
      "<li class=\"#{options[:selected_class]}\">#{nav_link(page)}</li>".html_safe
    elsif @page && @page.self_and_ancestors.include?(page)
      "<li class=\"#{options[:selected_class]}\">#{nav_link(page)}</li>".html_safe
    else
      "<li>#{nav_link(page)}</li>".html_safe
    end
  end
end
