Puppet::Type.newtype(:force10_firmwareupdate) do
  @doc = "This will perform firmware update on Dell Force10 switch."

  apply_to_device

  newparam(:name) do
    desc "Firmware name, can be any unique name"
    isnamevar
  end

  newparam(:force) do
    desc "This flag denotes force apply of firmware"
    newvalues(:true, :false)
    defaultto :false
  end

  newparam(:copy_to_tftp) do
    "2 element array, ['path to tftp share','path under tftp share']\nFor example: ['/var/lib/tftpshare','catalog1/firmware.bin']\n***Requires path param"
  end

  newparam(:path) do
    "The original firmware location path.  This has to be used in conjuction with to copy_to_tftp param"
  end

  newproperty(:url) do
    desc "URL of Firmware location "
    validate do |url|
      raise ArgumentError, "Command must be a String, got value of class #{url.class}" unless url.is_a? String
    end

  end

  newproperty(:returns, :event => :executed_command) do |property|
    munge do |value|
      value.to_s
    end

    def event_name
      :executed_command
    end

    defaultto "#"

    def change_to_s(currentvalue, newvalue)
      Puppet.debug(" current value: #{currentvalue} new value is : #{newvalue}")
      "executed successfully"
    end

    def retrieve
    end

    def sync
      event = :executed_command
      self.resource[:copy_to_tftp] ? copy_to_tftp = self.resource[:copy_to_tftp] : nil
      self.resource[:path] ? path = self.resource[:path] : nil
      out = provider.run(self.resource[:url], self.resource[:force], copy_to_tftp, path)
      event
    end
  end

  @isomorphic = false

  def self.instances
    []
  end

end
