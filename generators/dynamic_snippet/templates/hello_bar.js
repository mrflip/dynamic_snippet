// Hide the "This User bar sucks w/o Javascript" text
$(document).ready(function(){
  $("#hello-bar-no-yuo"  ).hide()
});

//
// Stuff into the #hello-bar div either:
//
// * if logged in, the username (linked to user's page) + a sign out link, or
// * if signed out, links to sign in or to create an account
//
function hello_bar_stuff(userid_and_name) {
  [userid, username] = userid_and_name.substr(0,50).split('#', 2);
  if ((!username) || (username == '_')) {
    $('#hello-bar').html(
      '<div id="hello-bar-greeting">Not signed in</div>'+
      '<div id="hello-bar-action" >(<a href="/signin" title="">sign up</a> | <a href="/signin" title="">sign in</a>)</div>');
  } else {
    $('#hello-bar').html(
      '<div id="hello-bar-greeting">Signed in as <a href="/users/'+userid+'">'+username+'</a></div>' +
      '<div id="hello-bar-action" >(<a href="/signout" title="Log out of Example Empty Site">sign out</a>)</div>'
    );
  }
}

//
// Pull the correct username from the site
//
function hello_bar_fetch()  {
  // see if we have stored the answer in our cookie
  var userid_and_name = $.cookie('userid_and_name');
  // if not, fetch the userid_and_name snippet
  if (userid_and_name) {
    // stuff the answer in.
    hello_bar_stuff(userid_and_name);
  } else {
    // get it, save it, stuff it in
    $.get('/users/userid_and_name', '', function(userid_and_name){
      if (userid_and_name != '_#_') { $.cookie('userid_and_name', userid_and_name, { path: '/', expires: null }); }
      hello_bar_stuff(userid_and_name);
    });
  } 
}
hello_bar_fetch();
