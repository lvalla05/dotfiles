local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local lazyurl = 'https://github.com/folke/lazy.nvim.git'
local lockpath = vim.fn.stdpath('config') .. '/lazy-lock.json'

local lockfile = assert(io.open(lockpath, 'r'))
local lock = vim.json.decode(lockfile:read('*a'))
lockfile:close()
local lazyentry = lock['lazy.nvim']
local lazycommit = lazyentry and lazyentry.commit
local lazybranch = lazyentry and lazyentry.branch
if type(lazycommit) ~= 'string' or #lazycommit ~= 40 or not lazycommit:match('^[0-9a-f]+$') then
  error('lazy-lock.json has no valid lazy.nvim commit')
end
if type(lazybranch) ~= 'string' or lazybranch == '' then
  error('lazy-lock.json has no valid lazy.nvim branch')
end

local function git(args, allow_failure)
  local command = { 'git', '-C', lazypath }
  vim.list_extend(command, args)
  local output = vim.fn.system(command)
  if vim.v.shell_error ~= 0 and not allow_failure then
    error('lazy.nvim bootstrap failed: ' .. vim.trim(output))
  end
  return vim.trim(output), vim.v.shell_error
end

if not vim.uv.fs_stat(lazypath .. '/.git') then
  if vim.uv.fs_stat(lazypath) then
    error(lazypath .. ' exists but is not a git checkout')
  end
  vim.fn.mkdir(lazypath, 'p')
  git({ 'init' })
  git({ 'remote', 'add', 'origin', lazyurl })
end

if git({ 'remote', 'get-url', 'origin' }) ~= lazyurl then
  error('lazy.nvim origin is not the expected repository')
end
git({ 'check-ref-format', '--branch', lazybranch })

local head = git({ 'rev-parse', 'HEAD' }, true)
if head ~= lazycommit then
  git({ 'fetch', '--filter=blob:none', '--depth=1', 'origin', lazycommit })
  git({ 'checkout', '--detach', lazycommit })
end
if git({ 'rev-parse', 'HEAD' }) ~= lazycommit then
  error('lazy.nvim checkout does not match lazy-lock.json')
end
git({ 'update-ref', 'refs/remotes/origin/' .. lazybranch, lazycommit })
git({ 'symbolic-ref', 'refs/remotes/origin/HEAD', 'refs/remotes/origin/' .. lazybranch })

vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugins')  -- load every file in lua/plugins/
