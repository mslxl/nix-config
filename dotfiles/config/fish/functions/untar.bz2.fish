# Defined in - @ line 1
function untar.bz2 --wraps='tar -xjvf' --description 'alias untar.bz2=tar -xjvf'
  tar -xjvf $argv;
end
