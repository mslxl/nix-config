# Defined in - @ line 1
function mkdirs --wraps='mkdir -p' --description 'alias mkdirs=mkdir -p'
  mkdir -p $argv;
end
