-- Build script for pgfornament

module = "pgfornament"
pgfornamv = "1.1"
pgfornamd = "2020/04/06"
tikzrputv = pgfornamv
tikzrputd = pgfornamd

-- Setting variables for .zip file (CTAN)
textfiles  = {"README.md"}
ctanreadme = "README.md"
ctanpkg    = module
ctanzip    = ctanpkg.."-"..pgfornamv
packtdszip = true  -- Change to false to not include .tds
flatten    = false
cleanfiles = {ctanzip..".curlopt", ctanzip..".zip"}

-- Creation of simplified structure for CTAN
local function make_ctan_tree()
  if direxists("code") then
    errorlevel = (cleandir("code/latex") + cleandir("code/generic/am")
                + cleandir("code/generic/pgfhan") + cleandir("code/generic/vectorian"))
    if errorlevel ~= 0 then
      error("** Error!!: Can't clean/remove files from ./code")
      return errorlevel
    end
  else
    errorlevel = (mkdir("code") + mkdir("code/latex") + mkdir("code/generic/am")
                + mkdir("code/generic/pgfhan") + mkdir("code/generic/vectorian"))
    if errorlevel ~= 0 then
      error("** Error!!: Can' t create the directory tree under ./code")
      return errorlevel
    end
  end
  errorlevel = (cp("*.*", "latex", "code/latex")
              + cp("*.pgf", "generic/am", "code/generic/am")
              + cp("*.pgf", "generic/pgfhan", "code/generic/pgfhan")
              + cp("*.pgf", "generic/vectorian", "code/generic/vectorian"))
  if errorlevel ~= 0 then
    error("** Error!!: Can't copy source files to directory tree under ./code")
    return errorlevel
  end
end

if options["target"] == "doc" or options["target"] == "ctan" or options["target"] == "install" then
  make_ctan_tree()
end

if options["target"] == "clean" then
  errorlevel = (cleandir("code/latex") + cleandir("code/generic/am") + cleandir("code/generic/pgfhan")
              + cleandir("code/generic/vectorian") + cleandir("code/generic") +cleandir("code"))
  lfs.rmdir("code")
end

-- Setting variables for package files
sourcefiledir = "code"
docfiledir    = "doc"
docfiles      = {"baseline.png", "ornaments.png", "TeX_box.png", "usefulcommands.tex"}
typesetfiles  = {"ornaments.tex", "tikzrput.tex"}
sourcefiles   = {"latex/*.*", "generic/am/*.pgf","generic/pgfhan/*.pgf","generic/vectorian/*.pgf"}
installfiles  = {"*.*"}

-- Setting file locations for local instalation (TDS)
tdslocations = {
  "tex/latex/pgfornament/pgfornament.sty",
  "tex/latex/pgfornament/tikzrput.sty",
  "tex/latex/pgfornament/pgflibraryam.code.tex",
  "tex/latex/pgfornament/pgflibrarypgfhan.code.tex",
  "tex/latex/pgfornament/pgflibraryvectorian.code.tex",
  "tex/generic/pgfornament/am/am*.pgf",
  "tex/generic/pgfornament/pgfhan/pgfhan*.pgf",
  "tex/generic/pgfornament/vectorian/vectorian*.pgf",
  "doc/latex/pgfornament/baseline.png",
  "doc/latex/pgfornament/ornaments.pdf",
  "doc/latex/pgfornament/ornaments.png",
  "doc/latex/pgfornament/ornaments.tex",
  "doc/latex/pgfornament/TeX_box.png",
  "doc/latex/pgfornament/usefulcommands.tex",
  "doc/latex/pgfornament/baseline.png",
  "doc/latex/pgfornament/tikzrput.pdf",
  "doc/latex/pgfornament/tikzrput.tex",
  "doc/latex/pgfornament/usefulcommands.tex",
}

-- Update package date and version
tagfiles = {"latex/pgfornament.sty", "latex/tikzrput.sty", "README.md", "doc/ornament.tex", "doc/tikzrput.tex"}

function update_tag(file, content, tagname, tagdate)
  if string.match(file, "pgfornament.sty$") then
    content = string.gsub(content,
                          "\\ProvidesPackage{pgfornament}%[%d%d%d%d%/%d%d%/%d%d v%d+.%d+%a* %s*(.-)%]",
                          "\\ProvidesPackage{pgfornament}["..pgfornamd.." v"..pgfornamv.." %1]")
  end
  if string.match(file, "tikzrput.sty$") then
    content = string.gsub(content,
                          "\\ProvidesPackage{tikzrput}%[%d%d%d%d%/%d%d%/%d%d v%d+.%d+%a* %s*(.-)%]",
                          "\\ProvidesPackage{tikzrput}["..tikzrputd.." v"..tikzrputv.." %1]")
  end
  if string.match(file, "README.md$") then
    content = string.gsub(content,
                          "Release %d+.%d+%a* %d%d%d%d%/%d%d%/%d%d",
                          "Release "..pgfornamv.." "..pgfornamd)
  end
  return content
end

-- Typesetting package documentation
typesetfiles = {"ornaments.tex", "tikzrput.tex"}
typesetexe   = "lualatex"
indexstyle   = ""

-- Load personal data
local ok, mydata = pcall(require, "Alaindata.lua")
if not ok then
  mydata = {email="XXX", uploader="YYY"}
end

-- CTAN upload config
uploadconfig = {
  author      = "Alain Matthes",
  uploader    = mydata.uploader,
  email       = mydata.email,
  pkg         = ctanpkg,
  version     = pgfornamv,
  license     = "lppl1.3c",
  summary     = "Drawing of Vectorian ornaments with PGF/TikZ",
  description = [[This package allows the drawing of Vectorian ornaments (196) with PGF/TikZ.\n The documentation presents the syntax and parameters of the macro "pgfornament".]],
  topic       = { "Graphics plot", "Decoration" },
  ctanPath    = "/macros/latex/contrib/tkz/"..ctanpkg,
  repository  = "https://github.com/tkz-sty/"..ctanpkg,
  bugtracker  = "https://github.com/tkz-sty/"..ctanpkg.."/issues",
  support     = "https://github.com/tkz-sty/"..ctanpkg.."/issues",
  announcement_file="ctan.ann",
  note_file   = "ctan.note",
  update      = true,
}

-- Print lines in 80 characters
local function os_message(text)
  local mymax = 77 - string.len(text) - string.len("done")
  local msg = text.." "..string.rep(".", mymax).." done"
  return print(msg)
end

-- Create check_marked_tags() function
local function check_marked_tags()
  local f = assert(io.open("latex/pgfornament.sty", "r"))
  marked_tags = f:read("*all")
  f:close()
  local m_pkgd, m_pkgv = string.match(marked_tags, "\\ProvidesPackage{pgfornament}%[(%d%d%d%d%/%d%d%/%d%d) v(%d+.%d+%a*) .-%]")
  if pgfornamv == m_pkgv and pgfornamd == m_pkgd then
    os_message("** Checking version and date: OK")
  else
    print("** Warning: pgfornament.sty is marked with version "..m_pkgv.." and date "..m_pkgd)
    print("** Warning: build.lua is marked with version "..pgfornamv.." and date "..pgfornamd)
    print("** Check version and date in build.lua then run l3build tag")
  end
end

-- Config tag_hook
function tag_hook(tagname)
  check_marked_tags()
end

-- Add "tagged" target to l3build CLI
if options["target"] == "tagged" then
  check_marked_tags()
  os.exit()
end

-- GitHub release version
local function os_capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

local gitbranch = os_capture("git symbolic-ref --short HEAD")
local gitstatus = os_capture("git status --porcelain")
local tagongit  = os_capture('git for-each-ref refs/tags --sort=-taggerdate --format="%(refname:short)" --count=1')
local gitpush   = os_capture("git log --branches --not --remotes")

if options["target"] == "release" then
  if gitbranch == "master" then
    os_message("** Checking git branch '"..gitbranch.."': OK")
  else
    error("** Error!!: You must be on the 'master' branch")
  end
  if gitstatus == "" then
    os_message("** Checking status of the files: OK")
  else
    error("** Error!!: Files have been edited, please commit all changes")
  end
  if gitpush == "" then
    os_message("** Checking pending commits: OK")
  else
    error("** Error!!: There are pending commits, please run git push")
  end
  check_marked_tags()

  local pkgversion = "v"..pgfornamv
  local pkgdate = pgfornamd
  os_message("** Checking last tag marked in GitHub "..tagongit..": OK")
  errorlevel = os.execute("git tag -a "..pkgversion.." -m 'Release "..pkgversion.." "..pkgdate.."'")
  if errorlevel ~= 0 then
    error("** Error!!: tag "..tagongit.." already exists, run git tag -d "..pkgversion.." && git push --delete origin "..pkgversion)
    return errorlevel
  else
    os_message("** Running: git tag -a "..pkgversion.." -m 'Release "..pkgversion.." "..pkgdate.."'")
  end
  os_message("** Running: git push --tags --quiet")
  os.execute("git push --tags --quiet")
  if fileexists(ctanzip..".zip") then
    os_message("** Checking "..ctanzip..".zip file to send to CTAN: OK")
  else
    os_message("** Creating "..ctanzip..".zip file to send to CTAN")
    os.execute("l3build ctan > "..os_null)
  end
  os_message("** Running: l3build upload -F ctan.ann --debug")
  os.execute("l3build upload -F ctan.ann --debug >"..os_null)
  print("** Now check "..ctanzip..".curlopt file and add changes to ctan.ann")
  print("** If everything is OK run (manually): l3build upload -F ctan.ann")
  os.exit(0)
end
