class Gem::Package
  def mkdir_p_safe mkdir, mkdir_options, destination_dir, file_name
    puts "mkdir_p_safe(#{mkdir.inspect}, #{mkdir_options.inspect}, #{destination_dir.inspect}, #{file_name.inspect}"
    destination_dir = realpath File.expand_path(destination_dir)
    parts = mkdir.split(File::SEPARATOR)
    puts "parts: #{parts.inspect}"
    parts.reduce do |path, basename|
      puts "reduce #{path.inspect}, #{basename.inspect}"
      path = realpath path  unless path == ""
      path = File.expand_path(path + File::SEPARATOR + basename)
      lstat = File.lstat path rescue nil
      if !lstat || !lstat.directory?
        puts "creating #{ [path, destination_dir, file_name].inspect }"
        unless path.start_with? destination_dir and (FileUtils.mkdir path, mkdir_options rescue false)
          raise Gem::Package::PathError.new(file_name, destination_dir)
        end
      end
      path
    end
  end
end
