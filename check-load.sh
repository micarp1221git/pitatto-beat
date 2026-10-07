#!/bin/zsh
# 公開前チェック（音程チェッカーの型を流用・canvasの代役を足した）: index.html の <script> を読み込んで、読み込み時に落ちないかを確かめる（9/21・IOS未定義参照で全ボタンが死んだ再発防止）
# 使い方: zsh check-load.sh   → 「runtime load ok」以外なら push しない
cd "$(dirname "$0")"
node -e "
const fs=require('fs');const s=fs.readFileSync('index.html','utf8');const m=s.match(/<script>([\s\S]*)<\/script>/);
const el=()=>({hidden:false,textContent:'',className:'',style:{},classList:{add(){},remove(){}},addEventListener(){},parentElement:{hidden:false},children:[],appendChild(){},querySelectorAll:()=>[],dataset:{},getContext:()=>new Proxy({},{get:(t,k)=>k in t?t[k]:()=>({addColorStop(){}}),set:(t,k,v)=>{t[k]=v;return true}}),setProperty(){},closest:()=>null,offsetWidth:0});
global.window={innerWidth:1280,innerHeight:800,devicePixelRatio:1,addEventListener(){},AudioContext:function(){this.state='running';this.resume=()=>Promise.resolve();}};global.navigator={userAgent:'iPhone',mediaDevices:{}};global.document={getElementById:el,querySelectorAll:()=>[],querySelector:el,addEventListener(){},createElement:el,body:el(),hidden:false};global.localStorage={getItem:()=>null,setItem(){}};global.Audio=function(){this.setAttribute=()=>{};this.play=()=>Promise.resolve();};global.URL={createObjectURL:()=>'blob:x'};global.Blob=function(){};global.requestAnimationFrame=()=>0;global.performance={now:()=>0};global.location={search:''};global.devicePixelRatio=1;
try{new Function(m[1])();console.log('runtime load ok');process.exit(0)}catch(e){console.log('RUNTIME ERROR:',e.message);process.exit(1)}"
