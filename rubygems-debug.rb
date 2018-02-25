class Gem::Package
  def mkdir_p_safe mkdir, mkdir_options, destination_dir, file_name
    destination_dir = realpath File.expand_path(destination_dir)
    parts = mkdir.split(File::SEPARATOR)
    p parts
    parts.reduce do |path, basename|
      path = realpath path  unless path == ""
      path = File.expand_path(path + File::SEPARATOR + basename)
      lstat = File.lstat path rescue nil
      if !lstat || !lstat.directory?
        p [path, destination_dir, file_name]
        unless path.start_with? destination_dir and (FileUtils.mkdir path, mkdir_options rescue false)
          raise Gem::Package::PathError.new(file_name, destination_dir)
        end
      end
      path
    end
  end
end
