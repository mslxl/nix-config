# Defined in - @ line 1
function untar.gz --wraps='tar -xzvf' --description 'alias untar.gz=tar -xzvf'
  tar -xzvf $argv;
end
