$obj = new-object -com ADSystemInfo
$type = $obj.gettype()
$type.InvokeMember("sitename","GetProperty",$null,$obj,$null) 