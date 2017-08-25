class Kite::Cloud

  def initialize(core, cloud_name)
    @core = core
    @name = cloud_name
    @core.destination_root = nil
  end

  def name
    @name
  end

  def core
    @core
  end

  def prepare
    core.directory('skel', name)
    core.inside(name) do
      core.chmod('bin/kite', 0755)
    end
  end

end
