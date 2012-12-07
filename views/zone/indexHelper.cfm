<cfoutput>
    <script>
        $( document ).ready(function() {
            $( '##save_zone' ).click(function(){
                saveZone(); 
            });
            $( '##delete_zone' ).click(function(){
                deleteZone();
            })
            $( '##zone_selector' ).change(function() {
                window.location= $( '##zone_selector option:selected' ).val();
            })
            function saveZone() {                              
                $( '##zone_form' )[0].submit();
            }
            function deleteZone() {
                var form = $( '##zone_form' )[0];
                var zoneID = $( '##zoneID' ).val();
                form.action = '#prc.xehDeleteLink#/zone/' + zoneID;
                apprise( 'Are you sure you want to delete this zone? This will remove this zone from any menus that specify it.', {
                    verify:true
                },function(r) {
                    if(r) {
                        form.submit();
                    }
                });
                return false;
            }
        });
    </script>
</cfoutput>