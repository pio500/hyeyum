/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	
    config.filebrowserBrowseUrl = '';
    config.filebrowserImageBrowseUrl = '';
    config.filebrowserFlashBrowseUrl = '';
    config.filebrowserUploadUrl = '/spring/resources/ckfinder/core/connector/java/connector.java?command=QuickUpload&type=Files';
    config.filebrowserImageUploadUrl = '/spring/resources/ckfinder/core/connector/java/connector.java?command=QuickUpload&type=Images';
    config.filebrowserFlashUploadUrl = '/spring/resources/ckfinder/core/connector/java/connector.java?command=QuickUpload&type=Flash';	

	// config.uiColor = '#AADC6E';
};
