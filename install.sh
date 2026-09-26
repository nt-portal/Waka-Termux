#!/bin/bash

set -e

BASHRC="$HOME/.bashrc"
WAKA_CFG="$HOME/.wakatime.cfg"
WAKA_DIR="$HOME/.wakatime"
LANGS_FILE="$WAKA_DIR/langs.txt"

pkg update -y
pkg install python -y
pip install wakatime

touch "$BASHRC"
mkdir -p "$WAKA_DIR"

if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$BASHRC"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$BASHRC"
fi

cat >"$LANGS_FILE" <<'WAKA_LANGS_EOF'
@dockerfile	Dockerfile
@containerfile	Dockerfile
@makefile	Makefile
@gnumakefile	Makefile
@cmakelists.txt	CMake
@rakefile	Ruby
@gemfile	Ruby
@podfile	Ruby
@vagrantfile	Ruby
@guardfile	Ruby
@brewfile	Ruby
@berksfile	Ruby
@thorfile	Ruby
@capfile	Ruby
@build.gradle	Gradle
@settings.gradle	Gradle
@go.mod	Go Module
@go.sum	Go Checksums
@cargo.toml	Cargo
@pipfile	Python
@.bashrc	Bash
@.bash_profile	Bash
@.bash_aliases	Bash
@.profile	Shell
@.zshrc	Zsh
@.zprofile	Zsh
@.vimrc	Vim Script
@.gvimrc	Vim Script
@.inputrc	Readline Config
@.editorconfig	EditorConfig
@.gitconfig	Git Config
@.gitignore	Git Ignore
@.gitattributes	Git Attributes
@.gitmodules	Git Modules
@.env	Dotenv
@conda.yaml	YAML
@jaxb.xml	XML
@web.xml	XML
c	C
cats	C
idc	C
cpp	C++
c++	C++
cc	C++
cp	C++
cxx	C++
hpp	C++
h++	C++
hh	C++
hxx	C++
inl	C++
ipp	C++
tpp	C++
tcc	C++
h	C/C++ Header
cs	C#
csx	C#
cake	C#
rs	Rust
rslib	Rust
go	Go
d	D
di	D
zig	Zig
zir	Zig
nim	Nim
nims	Nim
nimrod	Nim
nimble	Nim
v	V
vr	V
cr	Crystal
mojo	Mojo
odin	Odin
vala	Vala
vapi	Vala
swift	Swift
m	Objective-C
objc	Objective-C
mm	Objective-C++
adb	Ada
ada	Ada
ads	Ada
f	Fortran
f77	Fortran
f90	Fortran
f95	Fortran
f03	Fortran
f08	Fortran
for	Fortran
ftn	Fortran
fpp	Fortran
pas	Pascal
dfm	Pascal
lpr	Pascal
pp	Pascal
dpr	Delphi
mod	Modula-2
def	Modula-2
m3	Modula-3
i3	Modula-3
mg	Modula-3
ig	Modula-3
cps	Component Pascal
cob	COBOL
cbl	COBOL
ccp	COBOL
cobol	COBOL
cpy	COBOL
asm	Assembly
a51	Assembly
ags	Assembly
ass	Assembly
nasm	Assembly
s	Assembly
vmas	Assembly
wat	WebAssembly
wast	WebAssembly
wasm	WebAssembly
ll	LLVM
hc	HolyC
beef	Beef
carbon	Carbon
hare	Hare
jai	Jai
ino	Arduino
upc	Unified Parallel C
prx	xBase
java	Java
jav	Java
jsh	Java
kt	Kotlin
ktm	Kotlin
kts	Kotlin
scala	Scala
sc	Scala
groovy	Groovy
gvy	Groovy
gy	Groovy
clj	Clojure
boot	Clojure
cl2	Clojure
cljc	Clojure
cljx	Clojure
hic	Clojure
cljs	ClojureScript
cljs.hl	ClojureScript
aj	AspectJ
ceylon	Ceylon
gosu	Gosu
gst	Gosu
gsx	Gosu
vark	Gosu
xtend	Xtend
jasmin	Jasmin
gradle	Gradle
bzl	Starlark
star	Starlark
bazel	Bazel
py	Python
pyw	Python
pyi	Python
rpy	Python
wsgi	Python
xpy	Python
pyx	Cython
pxd	Cython
pxi	Cython
rb	Ruby
builder	Ruby
eye	Ruby
gemspec	Ruby
god	Ruby
jbuilder	Ruby
mspec	Ruby
pluginspec	Ruby
podspec	Ruby
rabl	Ruby
rake	Ruby
rbi	Ruby
rbx	Ruby
rjs	Ruby
ruby	Ruby
thor	Ruby
watchr	Ruby
php	PHP
php3	PHP
php4	PHP
php5	PHP
phps	PHP
phpt	PHP
aw	PHP
ctp	PHP
pl	Perl
al	Perl
cgi	Perl
fcgi	Perl
ph	Perl
plx	Perl
pm	Perl
psgi	Perl
raku	Raku
rakumod	Raku
p6	Raku
pl6	Raku
pm6	Raku
nqp	Raku
lua	Lua
nse	Lua
p8	Lua
pd_lua	Lua
rbxs	Lua
wlua	Lua
luau	Luau
tcl	Tcl
adp	Tcl
tm	Tcl
jl	Julia
r	R
rd	R
rsx	R
rda	R
rdata	R
rds	R
hy	Hy
io	Io
ik	Ioke
janet	Janet
fnl	Fennel
wren	Wren
moon	MoonScript
pike	Pike
pmod	Pike
be	Berry
red	Red
reds	Red
red-system	Red
dm	DM
monkey	Monkey
monkey2	Monkey
js	JavaScript
mjs	JavaScript
cjs	JavaScript
_js	JavaScript
bones	JavaScript
es	JavaScript
es6	JavaScript
jake	JavaScript
jsm	JavaScript
jss	JavaScript
ts	TypeScript
mts	TypeScript
cts	TypeScript
jsx	JSX
tsx	TSX
vue	Vue
svelte	Svelte
astro	Astro
html	HTML
htm	HTML
xhtml	HTML
hta	HTML
css	CSS
scss	SCSS
sass	Sass
less	Less
styl	Stylus
stylus	Stylus
pcss	PostCSS
postcss	PostCSS
sss	SugarSS
coffee	CoffeeScript
_coffee	CoffeeScript
cjsx	CoffeeScript
iced	CoffeeScript
litcoffee	Literate CoffeeScript
ls	LiveScript
_ls	LiveScript
elm	Elm
purs	PureScript
re	ReasonML
rei	ReasonML
res	ReScript
resi	ReScript
marko	Marko
mint	Mint
imba	Imba
qml	QML
qbs	QML
hs	Haskell
hsc	Haskell
lhs	Literate Haskell
ml	OCaml
mli	OCaml
mll	OCaml
mly	OCaml
eliom	OCaml
eliomi	OCaml
fs	F#
fsi	F#
fsx	F#
fsscript	F#
ex	Elixir
exs	Elixir
erl	Erlang
hrl	Erlang
xrl	Erlang
yrl	Erlang
escript	Erlang
lisp	Common Lisp
cl	Common Lisp
lsp	Common Lisp
ny	Common Lisp
podsl	Common Lisp
scm	Scheme
sld	Scheme
sls	Scheme
sps	Scheme
ss	Scheme
rkt	Racket
rktd	Racket
rktl	Racket
scrbl	Racket
sml	Standard ML
sig	Standard ML
fun	Standard ML
agda	Agda
lagda	Agda
idr	Idris
lidr	Idris
coq	Coq
lean	Lean
hlean	Lean
icl	Clean
dcl	Clean
curry	Curry
shen	Shen
grain	Grain
gr	Grain
lfe	LFE
nl	NewLisp
newlisp	NewLisp
ur	UrWeb
urs	UrWeb
fr	Frege
fut	Futhark
koka	Koka
kk	Koka
factor	Factor
fan	Fantom
self	Self
sh	Bash
bash	Bash
ebuild	Bash
eclass	Bash
bats	Bash
zsh	Zsh
fish	Fish
tcsh	Tcsh
csh	Tcsh
ksh	KornShell
ash	Shell
ps1	PowerShell
psm1	PowerShell
psd1	PowerShell
ps1xml	PowerShell
psc1	PowerShell
pssc	PowerShell
bat	Batchfile
cmd	Batchfile
nu	Nushell
awk	Awk
auk	Awk
gawk	Awk
mawk	Awk
nawk	Awk
sed	Sed
openrc	OpenRC runscript
json	JSON
avsc	JSON
geojson	JSON
topojson	JSON
sarif	JSON
tfstate	JSON
json5	JSON5
jsonc	JSONC
jsonld	JSON-LD
json-ld	JSON-LD
jsonnet	Jsonnet
libsonnet	Jsonnet
jsonl	JSON Lines
ndjson	JSON Lines
yml	YAML
yaml	YAML
toml	TOML
xml	XML
xsd	XML
wsdl	XML
rss	XML
atom	XML
axml	XML
adml	XML
admx	XML
pom	XML
xslt	XSLT
xsl	XSLT
xquery	XQuery
xq	XQuery
xql	XQuery
xqm	XQuery
xqy	XQuery
xpl	XProc
xproc	XProc
ini	INI
cfg	INI
cnf	INI
prefs	INI
conf	Config
properties	Java Properties
gitconfig	Git Config
csv	CSV
tsv	TSV
cson	CSON
dhall	Dhall
hcl	HCL
tf	HCL
tfvars	HCL
kdl	KDL
cue	CUE
ron	RON
nix	Nix
edn	edn
sexp	S-expression
md	Markdown
markdown	Markdown
mdown	Markdown
mdwn	Markdown
mkd	Markdown
mkdn	Markdown
mkdown	Markdown
mdx	MDX
adoc	AsciiDoc
asciidoc	AsciiDoc
asc	AsciiDoc
rst	reStructuredText
org	Org
textile	Textile
wikitext	Wikitext
mediawiki	Wikitext
wiki	Wikitext
tex	TeX
aux	TeX
bbl	TeX
bst	TeX
dtx	TeX
ins	TeX
ltx	TeX
sty	TeX
toc	TeX
typ	Typst
texi	Texinfo
texinfo	Texinfo
txi	Texinfo
roff	Roff
man	Roff
tmac	Roff
txt	Text
graphql	GraphQL
gql	GraphQL
graphqls	GraphQL
proto	Protocol Buffer
capnp	Cap'n Proto
thrift	Thrift
fbs	FlatBuffers
avdl	Avro IDL
gpx	GPX
sql	SQL
cql	SQL
ddl	SQL
mysql	SQL
pls	PLSQL
pks	PLSQL
pkb	PLSQL
plsql	PLSQL
pgsql	PLpgSQL
sqlite	SQLite
sqlite3	SQLite
sparql	SPARQL
rq	SPARQL
csl	Kusto
kql	Kusto
ql	CodeQL
qll	CodeQL
cyp	Cypher
cypher	Cypher
prisma	Prisma
hql	HiveQL
n1ql	N1QL
jinja	Jinja
jinja2	Jinja
j2	Jinja
handlebars	Handlebars
hbs	Handlebars
mustache	Mustache
twig	Twig
blade	Blade
blade.php	Blade
smarty	Smarty
tpl	Smarty
liquid	Liquid
ejs	EJS
erb	ERB
rhtml	ERB
pug	Pug
jade	Pug
haml	Haml
slim	Slim
razor	Razor
cshtml	Razor
ftl	FreeMarker
vm	Velocity
vtl	Velocity
latte	Latte
edge	Edge
mako	Mako
mao	Mako
ecr	HTML+ECR
heex	HTML+EEX
eex	HTML+EEX
phtml	HTML+PHP
veo	Verilog
sv	SystemVerilog
svh	SystemVerilog
vh	SystemVerilog
vhd	VHDL
vhdl	VHDL
vho	VHDL
vhi	VHDL
vhs	VHDL
vht	VHDL
vhw	VHDL
bsv	Bluespec
glsl	GLSL
fp	GLSL
frg	GLSL
fsh	GLSL
fshader	GLSL
geo	GLSL
geom	GLSL
glslf	GLSL
glslv	GLSL
gsh	GLSL
gshader	GLSL
rchit	GLSL
rgen	GLSL
rint	GLSL
rmiss	GLSL
comp	GLSL
tess	GLSL
vsh	GLSL
vshader	GLSL
vert	GLSL
vrx	GLSL
hlsl	HLSL
fx	HLSL
fxh	HLSL
hlsli	HLSL
wgsl	WGSL
metal	Metal
cu	CUDA
cuh	CUDA
opencl	OpenCL
shader	ShaderLab
pov	POV-Ray SDL
gco	G-code
gcode	G-code
gbr	Gerber Image
ger	Gerber Image
brd	Eagle
sch	Eagle
kicad_pcb	KiCad Layout
kicad_mod	KiCad Layout
kicad_wks	KiCad Layout
kicad_sch	KiCad Schematic
scad	OpenSCAD
sol	Solidity
vy	Vyper
cairo	Cairo
move	Move
clar	Clarity
yul	Yul
circom	Circom
tact	Tact
gd	GDScript
gml	Game Maker Language
uc	UnrealScript
pwn	Pawn
sma	Pawn
sp	SourcePawn
psc	Papyrus
sqf	SQF
hqf	SQF
lsl	LSL
lso	LSL
scd	SuperCollider
mat	MATLAB
mex	MATLAB
ma	Mathematica
mt	Mathematica
nb	Mathematica
nbp	Mathematica
wl	Mathematica
wlt	Mathematica
sci	Scilab
sce	Scilab
stan	Stan
gp	Gnuplot
gnu	Gnuplot
gnuplot	Gnuplot
plot	Gnuplot
plt	Gnuplot
mo	Modelica
do	Stata
ado	Stata
doh	Stata
ihlp	Stata
mata	Stata
matah	Stata
sthlp	Stata
sas	SAS
gap	GAP
gi	GAP
tst	GAP
m2	Macaulay2
sage	Sage
sagews	Sage
gaml	GAML
gms	GAMS
ampl	AMPL
ncl	NCL
ms	MAXScript
mcr	MAXScript
idl	IDL
pro	IDL
dl	IDL
ipf	IGOR Pro
vi	LabVIEW
moo	Mercury
dsp	Faust
prolog	Prolog
yap	Prolog
mzn	MiniZinc
dzn	MiniZinc
als	Alloy
clp	CLIPS
dfy	Dafny
smt2	SMT
smt	SMT
tla	TLA
bpl	Boogie
p4	P4
ecl	ECL
eclxml	ECL
eclip	ECLiPSe
cmake	CMake
cmake.in	CMake
mk	Makefile
mak	Makefile
meson	Meson
ninja	Ninja
bb	BitBake
bbappend	BitBake
bblayers	BitBake
pri	QMake
gn	GN
gni	GN
dockerfile	Dockerfile
containerfile	Dockerfile
nginx	Nginx
nginxconf	Nginx
apacheconf	Apache Configuration
vhost	Apache Configuration
spec	RPM Spec
robot	RobotFramework
feature	Gherkin
story	Gherkin
http	HTTP
rest	HTTP
vim	Vim Script
vimrc	Vim Script
gvimrc	Vim Script
reg	Windows Registry Entries
crontab	Crontab
cron	Crontab
as	ActionScript
applescript	AppleScript
scpt	AppleScript
ahk	AutoHotkey
ahkl	AutoHotkey
au3	AutoIt
bal	Ballerina
y	Bison
yacc	Bison
yy	Bison
bison	Bison
brs	Brightscript
chpl	Chapel
cfm	ColdFusion
cfc	ColdFusion
dart	Dart
el	Emacs Lisp
elisp	Emacs Lisp
eml	Emacs Lisp
hack	Hack
hhi	Hack
hx	Haxe
hxsl	Haxe
ni	Inform 7
i7x	Inform 7
iss	Inno Setup
isl	Inno Setup
ijs	J
ijc	J
ijt	J
krl	KRL
lasso	Lasso
las	Lasso
lasso8	Lasso
lasso9	Lasso
lgt	Logtalk
logtalk	Logtalk
lol	LOLCODE
lookml	LookML
lkml	LookML
mmd	Mermaid
mermaid	Mermaid
nf	Nextflow
qasm	OpenQASM
oz	Oz
pan	Pan
pir	Parrot
pasm	Parrot
puml	PlantUML
plantuml	PlantUML
iuml	PlantUML
pony	Pony
ps	PostScript
eps	PostScript
epfs	PostScript
pfa	PostScript
pbt	PowerBuilder
sra	PowerBuilder
srf	PowerBuilder
srm	PowerBuilder
srs	PowerBuilder
sru	PowerBuilder
srw	PowerBuilder
pb	PureBasic
pbi	PureBasic
qs	Q#
rl	Ragel
rex	REXX
rexx	REXX
rmd	RMarkdown
rg	Rouge
rnh	RUNOFF
rno	RUNOFF
scaml	Scaml
sl	Slash
ice	Slice
smali	Smali
st	Smalltalk
smithy	Smithy
cocci	SmPL
srt	SRecode Template
rnw	Sweave
snw	Sweave
tea	Tea
8xp	TI-Program
8xk	TI-Program
tu	Turing
ttl	Turtle
txl	TXL
uno	Uno
vdf	Valve Data Format
vcl	VCL
vba	VBA
vbs	VBScript
bas	Visual Basic
frm	Visual Basic
frx	Visual Basic
vb	Visual Basic .NET
vbhtml	Visual Basic .NET
volt	Volt
whiley	Whiley
xojo_code	Xojo
xojo_menu	Xojo
xojo_report	Xojo
xojo_script	Xojo
xojo_window	Xojo
yar	YARA
yara	YARA
zeek	Zeek
bro	Zeek
zs	ZenScript
zep	Zephir
zil	ZIL
mud	ZIL
abap	ABAP
apl	APL
dyalog	APL
arc	Arc
asy	Asymptote
aug	Augeas
bmx	BlitzMax
boo	Boo
bf	Brainfuck
ccl	Charcoal
ck	ChucK
cirru	Cirru
click	Click
csd	Csound
orc	Csound
sco	Csound
ec	eC
eh	eC
fy	Fancy
fancypack	Fancy
flux	FLUX
fth	Forth
4th	Forth
forth	Forth
frt	Forth
bi	FreeBasic
gs	Genie
golo	Golo
grace	Grace
gf	Grammatical Framework
hb	Harbour
prg	Harbour
ink	Ink
flex	JFlex
jflex	JFlex
ol	Jolie
iol	Jolie
kcl	KCL
kv	kvlang
lark	Lark
xm	Logos
xi	Logos
xmi	Logos
mam	M
mumps	M
m4	M4
mc	M4
mask	Mask
minid	MiniD
druby	Mirah
duby	Mirah
mirah	Mirah
motoko	Motoko
mq4	MQL4
mqh	MQL4
mq5	MQL5
mtml	MTML
muf	MUF
muse	Muse
myt	Myghty
nasl	NASL
nbin	NASL
ne	Nearley
nearly	Nearley
nemerle	Nemerle
neon	NEON
axs	NetLinx
axi	NetLinx
nlogo	NetLogo
nit	Nit
nss	NWScript
sj	Objective-J
omgrofl	Omgrofl
ooc	OOC
opa	Opa
ox	Ox
oxh	Ox
oxo	Ox
oxygene	Oxygene
pegjs	PEG.js
peggy	PEG.js
pig	PigLatin
pogo	PogoScript
rsc	Rascal
rdoc	RDoc
sieve	Sieve
swg	SWIG
wisp	Wisp
wlk	Wollok
x10	X10
xc	XC
xs	XS
yang	YANG
yasnippet	YASnippet
zap	ZAP
hxml	Hxml
thy	Isabelle
svg	SVG
svgz	SVG
sw	Sway
mtl	Wavefront Material
obj	Wavefront Object
owl	Web Ontology Language
webidl	WebIDL
wax	Wax
WAKA_LANGS_EOF

if ! grep -q '__wakatime_track' "$BASHRC"; then
cat >>"$BASHRC" <<'EOF'

if command -v wakatime >/dev/null 2>&1; then
    set +m

    declare -gA __WAKA_LANG=()
    __wakatime_load_langs() {
        local _k _v
        [ -f "$HOME/.wakatime/langs.txt" ] || return
        while IFS=$'\t' read -r _k _v; do
            case "$_k" in ''|'#'*) continue ;; esac
            __WAKA_LANG["${_k,,}"]="$_v"
        done <"$HOME/.wakatime/langs.txt"
    }
    __wakatime_load_langs

    __wakatime_get_project() {
        local _dir="${1:-$PWD}"
        if [ "$_dir" = "$HOME" ]; then
            echo "Home Termux"
        else
            basename "$_dir"
        fi
    }

    __wakatime_detect_lang() {
        local _name="${1,,}"
        local _lang="${__WAKA_LANG["@$_name"]}"
        [ -n "$_lang" ] || _lang="${__WAKA_LANG["${_name##*.}"]}"
        printf '%s\n' "${_lang:-Text}"
    }

    __wakatime_get_lang() {
        local _dir="${1:-$PWD}"
        local _entry _lang
        if [ "$_dir" = "$HOME" ]; then
            echo "C"
            return
        fi
        for _entry in "$_dir"/*; do
            [ -f "$_entry" ] || continue
            case "${_entry##*/}" in
                .*) continue ;;
                *.md|*.txt|*.rst|*.log) continue ;;
            esac
            _lang=$(__wakatime_detect_lang "${_entry##*/}")
            [ "$_lang" = "Text" ] && continue
            printf '%s\n' "$_lang"
            return
        done
        echo "Bash"
    }

    __wakatime_scan_files() {
        local _dir="$1"
        local _project="$2"
        local _count=0
        local _scan_file="$HOME/.wakatime/.scan_${_project}"

        if [ -f "$_scan_file" ]; then
            local _last_scan
            _last_scan=$(cat "$_scan_file" 2>/dev/null)
            local _now
            _now=$(date +%s)
            [ $((_now - _last_scan)) -lt 120 ] && return
        fi

        for _entry in "$_dir"/*; do
            [ -f "$_entry" ] || continue

            local _basename="${_entry##*/}"
            case "$_basename" in .*) continue ;; esac
            case "$_basename" in *.tar.gz|*.zip|*.7z|*.rar) continue ;;

            local _lang
            _lang=$(__wakatime_detect_lang "$_basename")

            wakatime \
                --plugin "termux-bash/2.0" \
                --entity "$_entry" \
                --entity-type file \
                --project "$_project" \
                --language "$_lang" \
                --category coding \
                --write \
                >/dev/null 2>&1

            _count=$((_count + 1))
        done

        date +%s >"$_scan_file" 2>/dev/null
    }

    __wakatime_track() {
        local _path="$PWD"
        local _project=$(__wakatime_get_project "$_path")
        local _lang=$(__wakatime_get_lang "$_path")
        echo "$_path" >"$HOME/.wakatime/.current_dir" 2>/dev/null
        (
            wakatime \
                --plugin "termux-bash/2.0" \
                --entity "$_path" \
                --entity-type file \
                --project "$_project" \
                --language "$_lang" \
                --category coding \
                --write \
                >/dev/null 2>&1
        ) </dev/null >/dev/null 2>&1 &
        disown 2>/dev/null
    }

    __wakatime_backup() {
        local _path="$1"
        local _project="$2"
        local _backup_dir="$HOME/.wakatime/backups"
        mkdir -p "$_backup_dir"
        [ "$_project" = "Home Termux" ] && return
        [[ "$_path" == "$_backup_dir"* ]] && return
        local _last_backup="$_backup_dir/.$_project.last_backup"
        local _now
        _now=$(date +%s)
        local _last=0
        [ -f "$_last_backup" ] && _last=$(cat "$_last_backup")
        if [ $((_now - _last)) -gt 86400 ]; then
            (
                tar -czf "$_backup_dir/${_project}_$(date +%Y%m%d_%H%M%S).tar.gz" \
                    -C "$(dirname "$_path")" \
                    "$(basename "$_path")" \
                    --exclude=".git" \
                    --exclude="node_modules" \
                    --exclude="*.tar.gz" \
                    >/dev/null 2>&1
                echo "$_now" >"$_last_backup"
                local _i=0
                for _bf in $(find "$_backup_dir" -maxdepth 1 \
                    -name "${_project}_*.tar.gz" -type f \
                    -printf '%T@ %p\n' 2>/dev/null \
                    | sort -rn | cut -d' ' -f2-); do
                    _i=$((_i + 1))
                    [ "$_i" -gt 5 ] && rm -f "$_bf"
                done
            ) &
            disown 2>/dev/null
        fi
    }

    __wakatime_timer() {
        local _tmpfile="$HOME/.wakatime/.current_dir"
        echo "$PWD" >"$_tmpfile"
        while true; do
            local _path
            _path=$(cat "$_tmpfile" 2>/dev/null || echo "$HOME")
            local _project=$(__wakatime_get_project "$_path")
            local _lang=$(__wakatime_get_lang "$_path")
            wakatime \
                --plugin "termux-bash/2.0" \
                --entity "$_path" \
                --entity-type file \
                --project "$_project" \
                --language "$_lang" \
                --category coding \
                --write \
                >/dev/null 2>&1
            [ "$_project" != "Home Termux" ] && __wakatime_scan_files "$_path" "$_project"
            [ "$_project" != "Home Termux" ] && __wakatime_backup "$_path" "$_project"
            sleep 60
        done
    }

    PROMPT_COMMAND="__wakatime_track${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

    if [ -z "$WAKATIME_TIMER_STARTED" ]; then
        export WAKATIME_TIMER_STARTED=1
        __wakatime_timer </dev/null >/dev/null 2>&1 &
        disown 2>/dev/null
    fi
fi
EOF
else
  echo "Integrasi WakaTime sudah ada di ~/.bashrc, melewati."
fi

if [ ! -f "$WAKA_CFG" ] || ! grep -q "api_key" "$WAKA_CFG"; then
  cat >"$WAKA_CFG" <<'EOF'
[settings]
api_key = waka_api
debug = false
hidefilenames = false
ignore =
    COMMIT_EDITMSG$
    PULLREQ_EDITMSG$
    MERGE_MSG$
    TAG_EDITMSG$
EOF
else
  sed -i 's/hidefilenames = true/hidefilenames = false/g' "$WAKA_CFG"
fi

echo "----------------------------------------------------"
echo "Instalasi selesai!"
echo "Edit ~/.wakatime.cfg dan ganti 'waka_api' dengan API key Anda."
echo "Dapatkan API key Anda di: https://wakatime.com/settings/account"
echo "----------------------------------------------------"
echo "BAHASA: $(grep -cv '^#' "$LANGS_FILE") entri dimuat dari $LANGS_FILE"
echo "Tambah manual: tambahkan baris 'ext<TAB>Bahasa' ke file tersebut, lalu 'source ~/.bashrc'"
echo "----------------------------------------------------"
echo "PANDUAN PENGGUNAAN:"
echo "1. Proyek 'Home Termux' (Bahasa: C) saat di \$HOME"
echo "2. Proyek 'Nama Folder' (Bahasa: deteksi otomatis) saat di folder lain"
echo "3. Backup otomatis disimpan di ~/.wakatime/backups"
echo "----------------------------------------------------"
echo "Jalankan: source ~/.bashrc"
echo "----------------------------------------------------"
