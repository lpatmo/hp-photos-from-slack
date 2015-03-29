
Photos = new Meteor.Collection("photos")
Meteor.startup ->
  Router.route '/', ->
    photos = Photos.find({}, sort: {"slack.timestamp": -1})
    @render 'gallery',
      data: {photos}

Template.gallery.helpers
  photo_title: ->
    @slack.title unless \
      _.any(["jpg", "png", "upload"],
            (badEnding) => @slack.title.toLowerCase().endsWith(badEnding)) or
      @slack.title.startsWith("DSC")
      
updateJustifiedGallery = -> 
  $('#gallery').justifiedGallery({
    rowHeight: 200,
    lastRow: 'nojustify',
    margins: 15})
    
populateTitles = ->
  $('#gallery a img').each(->
    $this = $(this)
    $this.parent().attr('title', $this.attr('alt')))
  
applySwipebox = ->
  $('#gallery a').swipebox()
      
updateGallery = ->
  updateJustifiedGallery()
  populateTitles()
  applySwipebox()

Template.gallery.onRendered ->
  @autorun ->
    Photos.find().count()  # solely to force reactivity in the method
    setTimeout(updateGallery, 250)