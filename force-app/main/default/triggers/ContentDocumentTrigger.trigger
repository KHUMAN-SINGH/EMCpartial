trigger ContentDocumentTrigger on ContentDocument (before insert) {
	
    for ( ContentDocument objCD : trigger.new ) {
			system.debug('objCD.ContentSize=='  + objCD.ContentSize);
        system.debug('objCD=='  + objCD);
        if ( objCD.Title == 'Driver Agreement' &&  objCD.ContentSize >= 12) {

            objCD.addError( 'Do not upload Test File' );

        }
    }
}