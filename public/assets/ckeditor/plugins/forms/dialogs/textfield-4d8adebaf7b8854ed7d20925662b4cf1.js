/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
CKEDITOR.dialog.add("textfield",function(e){var t={value:1,size:1,maxLength:1},a={text:1,password:1};return{title:e.lang.textfield.title,minWidth:350,minHeight:150,onShow:function(){var e=this;delete e.textField;var t=e.getParentEditor().getSelection().getSelectedElement();!t||"input"!=t.getName()||!a[t.getAttribute("type")]&&t.getAttribute("type")||(e.textField=t,e.setupContent(t))},onOk:function(){var e,t=this.textField,a=!t;a&&(e=this.getParentEditor(),t=e.document.createElement("input"),t.setAttribute("type","text")),a&&e.insertElement(t),this.commitContent({element:t})},onLoad:function(){var e=function(e){var t=e.hasAttribute(this.id)&&e.getAttribute(this.id);this.setValue(t||"")},a=function(e){var t=e.element,a=this.getValue();a?t.setAttribute(this.id,a):t.removeAttribute(this.id)};this.foreach(function(n){t[n.id]&&(n.setup=e,n.commit=a)})},contents:[{id:"info",label:e.lang.textfield.title,title:e.lang.textfield.title,elements:[{type:"hbox",widths:["50%","50%"],children:[{id:"_cke_saved_name",type:"text",label:e.lang.textfield.name,"default":"",accessKey:"N",setup:function(e){this.setValue(e.data("cke-saved-name")||e.getAttribute("name")||"")},commit:function(e){var t=e.element;this.getValue()?t.data("cke-saved-name",this.getValue()):(t.data("cke-saved-name",!1),t.removeAttribute("name"))}},{id:"value",type:"text",label:e.lang.textfield.value,"default":"",accessKey:"V"}]},{type:"hbox",widths:["50%","50%"],children:[{id:"size",type:"text",label:e.lang.textfield.charWidth,"default":"",accessKey:"C",style:"width:50px",validate:CKEDITOR.dialog.validate.integer(e.lang.common.validateNumberFailed)},{id:"maxLength",type:"text",label:e.lang.textfield.maxChars,"default":"",accessKey:"M",style:"width:50px",validate:CKEDITOR.dialog.validate.integer(e.lang.common.validateNumberFailed)}],onLoad:function(){CKEDITOR.env.ie7Compat&&this.getElement().setStyle("zoom","100%")}},{id:"type",type:"select",label:e.lang.textfield.type,"default":"text",accessKey:"M",items:[[e.lang.textfield.typeText,"text"],[e.lang.textfield.typePass,"password"]],setup:function(e){this.setValue(e.getAttribute("type"))},commit:function(t){var a=t.element;if(CKEDITOR.env.ie){var n=a.getAttribute("type"),i=this.getValue();if(n!=i){var o=CKEDITOR.dom.element.createFromHtml('<input type="'+i+'"></input>',e.document);a.copyAttributes(o,{type:1}),o.replace(a),e.getSelection().selectElement(o),t.element=o}}else a.setAttribute("type",this.getValue())}}]}]}});