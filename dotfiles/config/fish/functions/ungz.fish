# Defined in - @ line 1
function ungz --wraps='gzip -d' --description 'alias ungz=gzip -d'
  gzip -d $argv;
end
