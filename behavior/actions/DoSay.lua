
DoSay = class( "DoSay" ,Action)

function DoSay:ctor()
end

function DoSay:onDrive( tick )
    print(self.properties.content)
    return Status.SUCCESS
end
