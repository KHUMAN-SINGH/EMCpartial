trigger SetFileVisibility on ContentDocumentLink (before insert) {
    
    for (ContentDocumentLink cdl : Trigger.new) {
        Long docSize = cdl.ContentDocument.ContentSize;
        SetFileVisibilityHelper.FileSizeToString(docSize);
        system.debug('cdl==' + cdl);
        system.debug('docSize==' + docSize);
        
        cdl.visibility = 'AllUsers';  
    }
    
}