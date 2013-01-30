# encoding: utf-8

namespace :pages do
  namespace :development do

    desc "Generate test pages"
    task :generate_pages => :environment do
      required_vars = %w{NUMBER PARENT}
      required_vars.each do |var|
        unless ENV[var]
          puts "Usage:"
          puts "  rake pages:development:generate_pages NUMBER=<number> PARENT=<parent id> [IMAGES_DIR=<path to images>]"
          exit
        end
      end

      number = ENV['NUMBER'].to_i
      parent_page = Page.find(ENV['PARENT'])

      images = []
      if ENV['IMAGES_DIR']
        images = Dir.entries(ENV['IMAGES_DIR']).select{|f| f.downcase =~ /\.(jpg|jpeg|gif|png)$/}.map{|f| File.join(ENV['IMAGES_DIR'], f)}
      end

      users = User.find(:all)
      data = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent id est a elit porta varius quis nec lacus. Maecenas in augue dui, quis faucibus odio. Donec auctor purus a purus blandit sagittis. Morbi lorem risus, adipiscing sed eleifend sit amet, tempor quis felis. In gravida, diam eget ullamcorper lobortis, augue enim molestie dui, pulvinar viverra magna elit quis sapien. Curabitur rutrum vulputate quam ac dapibus. Quisque condimentum sagittis quam, ac dignissim dui cursus eu. Etiam non nulla et dui scelerisque accumsan in sed nisl. Mauris euismod turpis lectus. Cras id massa ut odio sagittis varius. Sed ut massa turpis, non laoreet felis. Maecenas a hendrerit metus. Maecenas accumsan leo ut ante scelerisque scelerisque. Donec laoreet lectus ac lorem faucibus sed vestibulum dui dictum. Donec scelerisque blandit iaculis. Donec condimentum ipsum non ligula consectetur eleifend. Praesent viverra vestibulum malesuada. Vestibulum suscipit tristique congue. Praesent sed quam ac lorem iaculis venenatis non id ante. Vivamus in adipiscing diam. Aliquam iaculis ligula sed urna hendrerit sit amet congue nisl congue. Integer felis odio, pretium in mattis vitae, faucibus in ipsum. In eu odio et tortor lobortis malesuada. Fusce fermentum tortor sit amet libero bibendum dapibus. Nullam consequat ligula eu turpis accumsan facilisis. Nam accumsan neque eleifend ligula blandit vel adipiscing sem tincidunt. Nullam feugiat, ante vitae egestas tincidunt, dui justo condimentum felis, quis facilisis purus neque eu nisl. Vivamus elementum erat et magna faucibus eu molestie lacus mollis. Vivamus tempor lorem a metus ornare eget mollis libero congue. Vestibulum non velit sed nulla bibendum interdum in in leo. Morbi aliquam semper nisl, quis aliquam nisi ullamcorper at. Mauris sed vulputate odio. Nulla eget orci lectus, id mattis mi. Morbi mattis ante sit amet mi condimentum eu euismod elit volutpat. Etiam nec quam ut diam gravida tempor quis quis felis. Vivamus gravida eros quis magna adipiscing nec convallis est euismod. Donec a risus non justo laoreet malesuada. In justo lorem, faucibus non sodales et, commodo eget tellus. Vivamus pellentesque ullamcorper consectetur. Proin rutrum adipiscing lectus, et luctus leo fermentum eget. In aliquet ante velit. Nunc nec velit sed lorem tempus vehicula. Etiam a nulla at elit tincidunt consequat at ac justo. Suspendisse rhoncus justo eget nisl tristique sed sagittis eros vestibulum. Duis ultrices bibendum felis eget adipiscing. Donec laoreet diam quis ipsum faucibus vitae sodales tellus vestibulum. Etiam vel tincidunt est. Cras faucibus turpis et sapien mattis vulputate. Curabitur vel nunc ac lorem laoreet scelerisque ac bibendum sem. Quisque eleifend, neque a vehicula fermentum, lacus purus viverra lorem, at dictum nisl nibh quis magna. Praesent cursus venenatis commodo. Vivamus luctus massa nec lacus lacinia pretium. Proin vulputate ipsum ut tortor lacinia dapibus. Pellentesque laoreet pulvinar felis eget ultrices. Maecenas dolor diam, varius at adipiscing rhoncus, vestibulum consequat orci. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Suspendisse eget tincidunt est. Vestibulum quis nisl nunc, vitae commodo tortor. Integer eget urna sit amet orci egestas consectetur. Sed orci neque, semper sollicitudin adipiscing sit amet, dignissim dapibus arcu. Donec a nisl ante, vitae faucibus dui. Vestibulum id venenatis elit. Morbi tempus tellus sed mi dictum id posuere quam tristique. Mauris mattis laoreet dolor sed hendrerit. Sed vel sapien lacus, et consequat sem. Sed bibendum sodales risus. Vivamus pellentesque tincidunt ullamcorper. Mauris augue nisl, feugiat vel lacinia eu, fringilla et turpis. Sed et massa ac lorem varius rhoncus. Vestibulum lacinia magna gravida metus posuere tempor. Nulla facilisi. Cras blandit, enim a pharetra gravida, massa arcu rhoncus odio, ut vehicula purus purus nec eros. Donec facilisis, nunc ac tincidunt ullamcorper, nibh tellus iaculis ligula, eget auctor risus turpis a libero. Aenean feugiat, ligula quis vehicula venenatis, purus libero pulvinar metus, faucibus porttitor tortor augue pharetra purus. Aliquam non justo molestie augue consectetur ornare. Curabitur lobortis dictum faucibus. Curabitur eros ipsum, congue vitae imperdiet non, dignissim sed leo. Nulla facilisi. Sed malesuada pretium iaculis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis id dolor et lectus feugiat dapibus ac sed sem. Phasellus eget ornare risus. Nunc aliquet varius arcu quis tristique. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Maecenas nulla nunc, rutrum sit amet luctus et, consequat eget nulla. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Maecenas et metus at tortor blandit adipiscing. Integer ultricies mattis erat non vestibulum. Nam ut est ante, sed suscipit lorem. Pellentesque non lacus enim. Fusce auctor, lorem non tristique cursus, ante orci auctor neque, eu ullamcorper erat ligula in nisl. Integer eget felis lacus. Aliquam sit amet ante quis velit vehicula porttitor. Donec sit amet orci risus, non scelerisque nibh. Sed faucibus adipiscing risus, sit amet pretium magna eleifend vitae. Ut risus augue, venenatis id suscipit id, auctor vel dui. Duis euismod aliquet mi, id placerat elit luctus eget. Ut et metus nibh, vel hendrerit tellus. Praesent in tellus odio, vitae sollicitudin libero. Vivamus diam nulla, lacinia sit amet aliquam id, posuere quis dui. Ut pellentesque lacinia magna, id scelerisque ante rutrum a. Maecenas mattis risus eget quam posuere viverra. Nulla felis metus, gravida ac adipiscing quis, ultrices in ante. Fusce hendrerit elementum lobortis. Etiam malesuada, nibh eu iaculis rhoncus, lectus felis rutrum diam, aliquet consequat nunc erat elementum orci. Sed sed odio at ipsum vehicula euismod. Duis et risus quam. Fusce congue, orci id sagittis accumsan, tellus purus pellentesque sem, sit amet porta justo nulla sit amet erat. Ut bibendum vehicula metus, vel pellentesque nulla tempor at. Nam dolor magna, porttitor et pretium in, dignissim quis ipsum. Proin volutpat egestas scelerisque. Aenean accumsan, nisi quis molestie convallis, ante metus tempor lorem, et commodo nisi nibh ac libero. Duis viverra ultricies dictum. Nulla mattis feugiat luctus. Curabitur eleifend magna ut diam dictum venenatis. Vivamus in congue turpis. Sed tempus tempus nisl et ornare. Quisque volutpat ornare libero, in scelerisque dui accumsan quis. Morbi viverra purus vitae metus sodales blandit. Vivamus cursus purus vel felis lobortis vitae pulvinar ipsum commodo. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Mauris eu turpis eget urna egestas pellentesque. Proin viverra eros id nibh mollis dictum. Ut egestas dignissim pellentesque. In est velit, sodales eget bibendum non, vulputate at erat. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Cras et tempus eros. Integer tincidunt, lorem at pretium aliquet, lacus nunc egestas velit, vel iaculis massa elit sed nunc. Donec ac urna non dui cursus luctus. Phasellus sem quam, semper sed imperdiet imperdiet, dignissim vel leo. Praesent non magna ac erat vehicula accumsan id sit amet dui. Donec sit amet ligula nisl, vel sodales mauris. Phasellus eleifend urna lorem. Fusce condimentum luctus velit ac pellentesque. Integer ultrices erat eu sem laoreet adipiscing. Aenean diam nibh, rutrum eget varius eu, aliquam condimentum purus. Duis mattis fringilla sem accumsan laoreet. Nulla scelerisque accumsan erat sed vestibulum. Donec ac nisi arcu, ac aliquam nisl. Nulla aliquam, turpis vel volutpat dictum, eros tortor porta arcu, quis sagittis urna nisi eget nulla. Sed non velit sit amet dolor aliquam scelerisque. Vivamus sit amet ultricies erat. Proin nec odio eu est aliquam tristique vel sed magna. Curabitur venenatis eleifend diam, vel tristique leo egestas nec. Vivamus eu dolor eu lectus consectetur elementum. Donec eleifend ipsum sit amet elit congue dapibus mattis enim fringilla. Aliquam sed diam odio. Sed porta pretium pretium. Nulla gravida suscipit elit, eget semper nisl sagittis nec. Duis vehicula, sapien ac ultricies placerat, eros eros sagittis ligula, at dignissim neque ligula at enim. Donec mattis, mauris imperdiet viverra commodo, tortor metus luctus lacus, sit amet tincidunt enim erat at purus. In in magna erat, eget adipiscing magna. Duis facilisis molestie enim, et ultrices ante eleifend et. Proin scelerisque leo id elit sagittis rutrum. Proin viverra erat id nisi dignissim id tristique arcu scelerisque. Nam lacus velit, volutpat non aliquam et, imperdiet vestibulum justo. In sed libero est, ac pretium quam. Sed molestie posuere nisl, a imperdiet nulla dictum ut. In ac tincidunt turpis. Morbi auctor molestie consectetur. Pellentesque id augue vel lacus vulputate ornare. Etiam posuere rutrum magna id ultrices. Donec congue sodales pellentesque. Mauris dapibus ligula vel sem luctus blandit tempus dui porta. Etiam interdum orci vel tortor tincidunt sodales. Pellentesque dolor est, adipiscing in auctor eu, viverra at lacus. Phasellus ac mauris risus, vitae posuere felis. Phasellus non tortor ac nisl mattis convallis sit amet non lectus. Ut tortor tortor, rhoncus non consequat vel, gravida vel turpis. Sed volutpat, nibh in ultricies dapibus, dui odio posuere odio, ut imperdiet ipsum est a nulla. Mauris libero velit, vulputate id laoreet vel, posuere ac urna. Fusce neque massa, euismod congue rutrum id, sollicitudin ac justo. Proin id commodo nisi. Sed consectetur rhoncus dui, in vestibulum felis molestie et. Morbi vitae risus vitae elit ultrices faucibus eu et lacus. Mauris egestas, est in euismod ultrices, diam augue interdum risus, sit amet aliquet odio enim at ante. Sed suscipit, massa ut condimentum tincidunt, libero lorem hendrerit felis, quis pharetra tellus odio id tortor. Fusce accumsan adipiscing ultrices. Pellentesque et felis ac ipsum tempor tempor. Phasellus dignissim augue sed nibh ullamcorper sit amet euismod quam mattis. Aliquam dolor nisi, ultricies a accumsan quis, commodo ut ante. Fusce convallis ultrices nisl sed tempor. Vivamus metus odio, venenatis ut rhoncus sed, tristique at urna. Quisque quis tincidunt erat. Ut lacinia nisi quis ante tristique auctor. Sed semper porta consequat. Cras lacus tortor, viverra id sollicitudin sit amet, tempor id tellus. Nulla luctus nibh urna. Aenean elit erat, fringilla a facilisis nec, auctor vel risus. Nulla facilisi. Vestibulum ipsum dui, ornare eget suscipit ac, dictum id sapien. Nunc eleifend magna quis ante imperdiet a posuere massa porta. Aenean congue odio eget turpis scelerisque id volutpat augue interdum. Nam porttitor commodo tortor, in convallis est dictum ut. Donec pulvinar imperdiet nulla, ut consectetur odio varius vitae. Nunc libero magna, congue sit amet pellentesque in, condimentum ac mauris. Fusce quis neque sed augue iaculis bibendum ut vel est. In aliquam porttitor erat at tincidunt. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Sed eget nisl vitae dui feugiat ultrices vitae vel odio. Maecenas lorem ligula, faucibus vel vestibulum nec, dignissim sed sapien. Nam suscipit lacus in quam elementum placerat. Aliquam erat volutpat. Integer lacinia dapibus eros, elementum semper nulla vulputate id. In hac habitasse platea dictumst. Donec quis lorem mauris. Nam vestibulum viverra massa, sit amet mollis nisi pulvinar quis. Praesent suscipit eros at sapien dapibus mollis. Donec et neque nulla. Phasellus rhoncus, est vitae condimentum viverra, arcu felis tristique leo, at rutrum nisi dui nec odio. Proin at eros magna. Praesent ac felis orci. Donec accumsan feugiat dui non lacinia. Mauris ante tellus, mattis sit amet posuere aliquet, molestie vel nisi. Sed tristique lacus a sem convallis volutpat. Duis vulputate hendrerit neque, eget bibendum leo sodales id. Nam sollicitudin scelerisque mi, eget ullamcorper urna scelerisque in. Quisque ac sollicitudin libero. Integer elementum est ac felis ultrices vitae vulputate nibh interdum. Morbi vitae magna odio, nec pharetra massa. Quisque sodales, ante vel mattis rhoncus, ipsum sapien egestas augue, et dignissim nulla quam sit amet libero. Vestibulum aliquet urna et metus feugiat a molestie ipsum ornare. Aliquam viverra volutpat varius."
      sentences = data.split(/\s*\.\s*/).map{|s| "#{s}."}
      titles = data.split(/\s*[\.,;]\s*/).select{|t| t.length < 40}.map{|t| t.capitalize}

      number.times do
        create_options = {
          :parent_page_id => parent_page.id,
          :status  => 2,
          :published_at => (Time.now - (rand(129600)).minutes),
          :name    => titles[rand(titles.length)],
          :excerpt => (0..(2+rand(3))).to_a.map{sentences[rand(sentences.length)]}.join(" "),
          :body    => (0..(1+rand(4))).to_a.map{(0..(3+rand(6))).to_a.map{sentences[rand(sentences.length)]}.join(" ")}.join("\n\n"),
          :author  => users[rand(users.length)]
        }
        if images.length > 0
          create_options[:image] = File.open(images[rand(images.length)])
        end

        page = Page.new
        page.update_attributes(create_options)
      end
    end

  end
end
