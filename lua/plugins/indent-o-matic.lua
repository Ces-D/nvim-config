local indent_ok, indentOMatic = pcall(require, 'indent-o-matic')
if not indent_ok then
  return
end

indentOMatic.setup{}
