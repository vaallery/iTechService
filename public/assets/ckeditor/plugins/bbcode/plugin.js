/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
!function(){function e(e){var t="";for(var a in e){var n=e[a],i=(a+":"+n).replace(c,";");t+=i}return t}function t(e){var t={};return(e||"").replace(/&quot;/g,'"').replace(/\s*([^ :;]+)\s*:\s*([^;]+)\s*(?=;|$)/g,function(e,a,n){t[a.toLowerCase()]=n}),t}function a(e){return e.replace(/(?:rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\))/gi,function(e,t,a,n){t=parseInt(t,10).toString(16),a=parseInt(a,10).toString(16),n=parseInt(n,10).toString(16);for(var i=[t,a,n],o=0;o<i.length;o++)i[o]=String("0"+i[o]).slice(-2);return"#"+i.join("")})}CKEDITOR.on("dialogDefinition",function(e){var t,a=e.data.name,n=e.data.definition;"link"==a?(n.removeContents("target"),n.removeContents("upload"),n.removeContents("advanced"),t=n.getContents("info"),t.remove("emailSubject"),t.remove("emailBody")):"image"==a&&(n.removeContents("advanced"),t=n.getContents("Link"),t.remove("cmbTarget"),t=n.getContents("info"),t.remove("txtAlt"),t.remove("basic"))});var n={b:"strong",u:"u",i:"em",color:"span",size:"span",quote:"blockquote",code:"code",url:"a",email:"span",img:"span","*":"li",list:"ol"},i={strong:"b",b:"b",u:"u",em:"i",i:"i",code:"code",li:"*"},o={strong:"b",em:"i",u:"u",li:"*",ul:"list",ol:"list",code:"code",a:"link",img:"img",blockquote:"quote"},r={color:"color",size:"font-size"},s={url:"href",email:"mailhref",quote:"cite",list:"listType"},l=CKEDITOR.dtd,d=CKEDITOR.tools.extend({table:1},l.$block,l.$listItem,l.$tableContent,l.$list),c=/\s*(?:;\s*|$)/,u={smiley:":)",sad:":(",wink:";)",laugh:":D",cheeky:":P",blush:":*)",surprise:":-o",indecision:":|",angry:">:(",angel:"o:)",cool:"8-)",devil:">:-)",crying:";(",kiss:":-*"},p={},m=[];for(var h in u)p[u[h]]=h,m.push(u[h].replace(/\(|\)|\:|\/|\*|\-|\|/g,function(e){return"\\"+e}));m=new RegExp(m.join("|"),"g");var g=function(){var e=[],t={nbsp:" ",shy:"­",gt:">",lt:"<"};for(var a in t)e.push(a);return e=new RegExp("&("+e.join("|")+");","g"),function(a){return a.replace(e,function(e,a){return t[a]})}}();CKEDITOR.BBCodeParser=function(){this._={bbcPartsRegex:/(?:\[([^\/\]=]*?)(?:=([^\]]*?))?\])|(?:\[\/([a-z]{1,16})\])/gi}},CKEDITOR.BBCodeParser.prototype={parse:function(t){for(var a,i,o=this,l=0;a=o._.bbcPartsRegex.exec(t);){var d=a.index;if(d>l){var c=t.substring(l,d);o.onText(c,1)}if(l=o._.bbcPartsRegex.lastIndex,i=(a[1]||a[3]||"").toLowerCase(),!i||n[i])if(a[1]){var u=n[i],p={},m={},h=a[2];h&&("list"==i&&(isNaN(h)?/^[a-z]+$/.test(h)?h="lower-alpha":/^[A-Z]+$/.test(h)&&(h="upper-alpha"):h="decimal"),r[i]?("size"==i&&(h+="%"),m[r[i]]=h,p.style=e(m)):s[i]&&(p[s[i]]=h)),("email"==i||"img"==i)&&(p.bbcode=i),o.onTagOpen(u,p,CKEDITOR.dtd.$empty[u])}else a[3]&&o.onTagClose(n[i]);else o.onText(a[0])}t.length>l&&o.onText(t.substring(l,t.length),1)}},CKEDITOR.htmlParser.fragment.fromBBCode=function(e){function t(e){if(l.length>0)for(var t=0;t<l.length;t++){var a=l[t],n=a.name,i=CKEDITOR.dtd[n],o=u.name&&CKEDITOR.dtd[u.name];o&&!o[n]||e&&i&&!i[e]&&CKEDITOR.dtd[e]||(a=a.clone(),a.parent=u,u=a,l.splice(t,1),t--)}}function a(e,t){var a=u.children.length,n=a>0&&u.children[a-1],i=!n&&f.getRule(o[u.name],"breakAfterOpen"),r=n&&n.type==CKEDITOR.NODE_ELEMENT&&f.getRule(o[n.name],"breakAfterClose"),s=e&&f.getRule(o[e],t?"breakBeforeClose":"breakBeforeOpen");c&&(i||r||s)&&c--,c&&e in d&&c++;for(;c&&c--;)u.children.push(n=new CKEDITOR.htmlParser.element("br"))}function n(e,t){a(e.name,1),t=t||u||s;var n=t.children.length,i=n>0&&t.children[n-1]||null;e.previous=i,e.parent=t,t.children.push(e),e.returnPoint&&(u=e.returnPoint,delete e.returnPoint)}var i,r=new CKEDITOR.BBCodeParser,s=new CKEDITOR.htmlParser.fragment,l=[],c=0,u=s;r.onTagOpen=function(e,o){var s=new CKEDITOR.htmlParser.element(e,o);if(CKEDITOR.dtd.$removeEmpty[e])return l.push(s),void 0;var d=u.name,c=d&&(CKEDITOR.dtd[d]||(u._.isBlockLike?CKEDITOR.dtd.div:CKEDITOR.dtd.span));if(c&&!c[e]){var p,m=!1;if(e==d?n(u,u.parent):e in CKEDITOR.dtd.$listItem?(r.onTagOpen("ul",{}),p=u,m=!0):(n(u,u.parent),l.unshift(u),m=!0),u=p?p:u.returnPoint||u.parent,m)return r.onTagOpen.apply(this,arguments),void 0}t(e),a(e),s.parent=u,s.returnPoint=i,i=0,s.isEmpty?n(s):u=s},r.onTagClose=function(e){for(var t=l.length-1;t>=0;t--)if(e==l[t].name)return l.splice(t,1),void 0;for(var a=[],i=[],o=u;o.type&&o.name!=e;)o._.isBlockLike||i.unshift(o),a.push(o),o=o.parent;if(o.type){for(t=0;t<a.length;t++){var r=a[t];n(r,r.parent)}u=o,n(o,o.parent),o==u&&(u=u.parent),l=l.concat(i)}},r.onText=function(e){var i=CKEDITOR.dtd[u.name];(!i||i["#"])&&(a(),t(),e.replace(/([\r\n])|[^\r\n]*/g,function(e,t){if(void 0!==t&&t.length)c++;else if(e.length){var a=0;e.replace(m,function(t,i){n(new CKEDITOR.htmlParser.text(e.substring(a,i)),u),n(new CKEDITOR.htmlParser.element("smiley",{desc:p[t]}),u),a=i+t.length}),a!=e.length&&n(new CKEDITOR.htmlParser.text(e.substring(a,e.length)),u)}}))},r.parse(CKEDITOR.tools.htmlEncode(e));for(;u.type;){var h=u.parent,g=u;n(g,h),u=h}return s},CKEDITOR.htmlParser.BBCodeWriter=CKEDITOR.tools.createClass({$:function(){var e=this;e._={output:[],rules:[]},e.setRules("list",{breakBeforeOpen:1,breakAfterOpen:1,breakBeforeClose:1,breakAfterClose:1}),e.setRules("*",{breakBeforeOpen:1,breakAfterOpen:0,breakBeforeClose:1,breakAfterClose:0}),e.setRules("quote",{breakBeforeOpen:1,breakAfterOpen:0,breakBeforeClose:0,breakAfterClose:1})},proto:{setRules:function(e,t){var a=this._.rules[e];a?CKEDITOR.tools.extend(a,t,!0):this._.rules[e]=t},getRule:function(e,t){return this._.rules[e]&&this._.rules[e][t]},openTag:function(e,t){var a=this;if(e in n){a.getRule(e,"breakBeforeOpen")&&a.lineBreak(1),a.write("[",e);var i=t.option;i&&a.write("=",i),a.write("]"),a.getRule(e,"breakAfterOpen")&&a.lineBreak(1)}else"br"==e&&a._.output.push("\n")},openTagClose:function(){},attribute:function(){},closeTag:function(e){var t=this;e in n&&(t.getRule(e,"breakBeforeClose")&&t.lineBreak(1),"*"!=e&&t.write("[/",e,"]"),t.getRule(e,"breakAfterClose")&&t.lineBreak(1))},text:function(e){this.write(e)},comment:function(){},lineBreak:function(){var e=this;!e._.hasLineBreak&&e._.output.length&&(e.write("\n"),e._.hasLineBreak=1)},write:function(){this._.hasLineBreak=0;var e=Array.prototype.join.call(arguments,"");this._.output.push(e)},reset:function(){this._.output=[],this._.hasLineBreak=0},getHtml:function(e){var t=this._.output.join("");return e&&this.reset(),g(t)}}});var f=new CKEDITOR.htmlParser.BBCodeWriter;CKEDITOR.plugins.add("bbcode",{requires:["htmldataprocessor","entities"],beforeInit:function(e){var t=e.config;CKEDITOR.tools.extend(t,{enterMode:CKEDITOR.ENTER_BR,basicEntities:!1,entities:!1,fillEmptyBlocks:!1},!0)},init:function(e){function n(e){var t=CKEDITOR.htmlParser.fragment.fromBBCode(e),a=new CKEDITOR.htmlParser.basicWriter;return t.writeHtml(a,r),a.getHtml(!0)}var o=e.config,r=new CKEDITOR.htmlParser.filter;r.addRules({elements:{blockquote:function(e){var t=new CKEDITOR.htmlParser.element("div");t.children=e.children,e.children=[t];var a=e.attributes.cite;if(a){var n=new CKEDITOR.htmlParser.element("cite");n.add(new CKEDITOR.htmlParser.text(a.replace(/^"|"$/g,""))),delete e.attributes.cite,e.children.unshift(n)}},span:function(e){var t;(t=e.attributes.bbcode)&&("img"==t?(e.name="img",e.attributes.src=e.children[0].value,e.children=[]):"email"==t&&(e.name="a",e.attributes.href="mailto:"+e.children[0].value),delete e.attributes.bbcode)},ol:function(e){e.attributes.listType?"decimal"!=e.attributes.listType&&(e.attributes.style="list-style-type:"+e.attributes.listType):e.name="ul",delete e.attributes.listType},a:function(e){e.attributes.href||(e.attributes.href=e.children[0].value)},smiley:function(e){e.name="img";var t=e.attributes.desc,a=o.smiley_images[CKEDITOR.tools.indexOf(o.smiley_descriptions,t)],n=CKEDITOR.tools.htmlEncode(o.smiley_path+a);e.attributes={src:n,"data-cke-saved-src":n,title:t,alt:t}}}}),e.dataProcessor.htmlFilter.addRules({elements:{$:function(n){var o,r=n.attributes,s=t(r.style),l=n.name;if(l in i)l=i[l];else if("span"==l){if(o=s.color)l="color",o=a(o);else if(o=s["font-size"]){var d=o.match(/(\d+)%$/);d&&(o=d[1],l="size")}}else if("ol"==l||"ul"==l){if(o=s["list-style-type"])switch(o){case"lower-alpha":o="a";break;case"upper-alpha":o="A"}else"ol"==l&&(o=1);l="list"}else if("blockquote"==l){try{var c=n.children[0],p=n.children[1],m="cite"==c.name&&c.children[0].value;m&&(o='"'+m+'"',n.children=p.children)}catch(h){}l="quote"}else if("a"==l){if(o=r.href)if(-1!==o.indexOf("mailto:"))l="email",n.children=[new CKEDITOR.htmlParser.text(o.replace("mailto:",""))],o="";else{var g=1==n.children.length&&n.children[0];g&&g.type==CKEDITOR.NODE_TEXT&&g.value==o&&(o=""),l="url"}}else if("img"==l){n.isEmpty=0;var f=r["data-cke-saved-src"];if(f&&-1!=f.indexOf(e.config.smiley_path))return new CKEDITOR.htmlParser.text(u[r.alt]);n.children=[new CKEDITOR.htmlParser.text(f)]}return n.name=l,o&&(n.attributes.option=o),null},br:function(e){var t=e.next;return t&&t.name in d?!1:void 0}}},1),e.dataProcessor.writer=f,e.on("beforeSetMode",function(t){t.removeListener();var a=e._.modes.wysiwyg;a.loadData=CKEDITOR.tools.override(a.loadData,function(e){return function(t){return e.call(this,n(t))}})})},afterInit:function(e){var t;e._.elementsPath&&(t=e._.elementsPath.filters)&&t.push(function(t){var a=t.getName(),n=o[a]||!1;if("link"==n&&0===t.getAttribute("href").indexOf("mailto:"))n="email";else if("span"==a)t.getStyle("font-size")?n="size":t.getStyle("color")&&(n="color");else if("img"==n){var i=t.data("cke-saved-src");i&&0===i.indexOf(e.config.smiley_path)&&(n="smiley")}return n})}})}();