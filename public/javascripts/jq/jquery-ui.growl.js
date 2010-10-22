/**
 * @name	jquery-ui.growl.js
 * @version	0.1 6-apr-2010
 * @author	Jaap Moolenaar, Websteen.nl
 *
 * DESCRIPTION *
 * -----------------------------------------------------------------------------
 * A plugin for jQuery UI to show Mac OS type Growls
 * It simply show a jQuery UI dialog in the bottom right corner and dissapears
 * with a custom effect. Every seperate growl piles on top of others.
 * Scrolling the page scrolls the growls along as well
 *
 * To show a growl simply do:
 * $.WsGrowl.show({content: '<p>Growling away!</p>'});
 *
 * Available options to be passed as parameters:
 * @var string  title           The title to show, no title hides the title AND
 *                              the close button.
 * @var string  content         Whatever content you would like to show in the
 *                              growl @see jQueryUI.dialog()
 * @var integer timeout         The number of seconds to show the growl TOTAL,
 *                              a growl at the bottom for 8s would dissapear
 *                              later then a growl on top of it for 2s
 * @var integer dialogMargin    The vertical spacing between 2 growls
 * @var integer hideSpeed       The duration of the hide effect
 * @var object  dialog          Any other option you want to pass to the dialog,
 *                              you cannot pass the following:
 *                              'resizable', 'draggable', 'position',
 *                              'open', 'beforeClose'
 *
 * @TODO:   - Write comments in english
 *          - Possibly figure out a nice incremental timing method...
 * -----------------------------------------------------------------------------
 *
 * VERSION HISTORY *
 * ---------------------------------------------------------------------------
 * - 1.0 - Jaap Moolenaar
 * ---------------------------------------------------------------------------
 * - No Comment
 * ---------------------------------------------------------------------------
 */

$.WsGrowl = {
    // default options
    opt : {
        title: false,
        content: false,
        timeout: 2000,
        dialogMargin: 10,
        hideSpeed: 350,
        dialog: {}
    },
    
    aGrowls: [],

    // dont scroll animate when this is true...
    bAnimating : false,

    /**
     * Laat een Growl zien,
     * Is in feite een jQuery UI Dialog gepositioneerd rechts onderin
     * Echter wordt elke growl boven de andere getoond en wordt er een afwijkende animatie gebruikt
     */
    show: function(options){
        // extend de default opties
        var opt = $.extend({}, this.opt, options);

        // geen content is meteen klaar
        if(!opt.content) return false;

        // maak een nieuw ID
        var iNewGrowlID = 'Growl_'+Math.floor(Math.random()*100);

        // maak een nieuw element
        var newGrowl =
            $('<div id="'+iNewGrowlID+'"></div>')
            .html( opt.content )
            .appendTo( $('body') )
            .hide();

        // bewaar de opties voor deze growl
        newGrowl.data('opt', opt);
        newGrowl.data('gid', iNewGrowlID);

        // bepaal de default dialog options
        var oDialogOpts = {
                resizable: false,
                draggable: false,
                position: ['right', 'bottom'],

                // als de dialog geopend is
                open: function(e, ui){
                    var $this   = $(this);

                    // verberg de titel en verplaats de dialog een stuk omlaag
                    if(!opt.title)
                    {
                        var oTitle = $this.parent().find('.ui-dialog-titlebar');
                        var iTitleHeight = oTitle.outerHeight();
                            oTitle.hide();

                        $this.parent().animate({top: '+='+iTitleHeight}, 0);
                    }

                    // her-postitioneer als er meerdere growls zijn
                    var iTop = $this.parent().position().top - opt.dialogMargin;
                    $.each($.WsGrowl.aGrowls, function(){
                        iTop -= ( this.parent().outerHeight() + opt.dialogMargin );
                    });

                    // her positionering uitvoeren
                    $this.parent().animate({top: iTop}, 0);

                    // na de opgegeven timeout gaan we dit element weer verbergen
                    setTimeout(function(){
                        $this.dialog('close');
                    }, opt.timeout);
                },

                beforeClose: function(e, ui){
                    var $this   = $(this);
                    var iThisID = $this.data('gid');
                    var iThisHeight = $this.parent().outerHeight();

                    // animeer de hoogte naar 0 en verhoog de top met de hoogte van dit element
                    $this.parent().animate(
                        {height: 0, top: '+='+iThisHeight, opacity: 0.2},
                        {
                            duration: opt.hideSpeed,

                            // verwijder dit element en her positioneer
                            complete: function(){ $(this).remove(); $.WsGrowl.repos(); }
                        }
                    );

                    // kijk welk element verwijderd moet worden
                    var iKeyToRemove = 0;

                    // kijk of dit element in de loop het zojuist verwijderde element is
                    $.each( $.WsGrowl.aGrowls, function(iKey){
                        // deze moet nog uit de array worden gehaald
                        if( $(this).is('#'+iThisID) ) iKeyToRemove = iKey;
                    });

                    // haal het zojuist verwijderde element uit de growls array
                    $.WsGrowl.aGrowls.splice(iKeyToRemove, 1);

                    return false;
                }
            };

        // bepaal een eventuele titel
        if(opt.title)
        {
           oDialogOpts.title = opt.title;
        }

        // extend deze opties met de eventuele options
        oDialogOpts = $.extend({}, opt.dialog, oDialogOpts);

        // laat het element zien met jQuery UI
        newGrowl.dialog(oDialogOpts);

        //voeg de dialog toe aan de totale growls
        this.aGrowls.push(newGrowl);

        // return de dialog
        return newGrowl;
    },

    /**
     * Herpositioneer de growls rechtsonderin
     * Alleen als deze animatie niet al bezig is, kan dus aan een scroll even worden gekoppeld
     */
    repos: function(){
        // als er niet geanimeerd wordt
        if(!this.bAnimating)
        {
            // we zijn nu aan het animeren
            this.bAnimating = true;

            // haal het window op om positie te bepalen
            var wnd = $(window);
            var iTop = wnd.height() + wnd.scrollTop();

            // loop door alle growls heen, herbereken de top en pas deze aan
            $.each($.WsGrowl.aGrowls, function(){

                // stop de vorige animatie
                this.parent().stop(true, true);

                // bereken den nieuwe top
                iTop -= this.parent().outerHeight() + this.data('opt').dialogMargin;

                // animeer naar de nieuwe top
                this.parent().animate({top: iTop}, {duration: 450, stack: false});
            });

            // we zijn klaar met animren
            this.bAnimating = false;
        }
    }
};

$.fn.WsGrowl = function(options){
    return $(this).each(function(){

        // check and see if element has a title
        if($(this).attr('title')) options.title = $(this).attr('title');

        // grab all contents
        options.content = $(this).html();

        // show growl
        $.WsGrowl.show(options);
    });
};

// hook the window scroll event to move along the growls
$(window).scroll(function(){
    $.WsGrowl.repos();
});

