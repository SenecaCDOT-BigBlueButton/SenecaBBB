<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seneca | Conferece Management System</title>
<link rel="shortcut icon" href="http://www.cssreset.com/favicon.png" />
<!--<link href="css/style.css" rel="stylesheet" type="text/css" media="screen and (min-width:1280px)">-->
<link href="css/style.css" rel="stylesheet" type="text/css" media="all">
<noscript>
<link rel="stylesheet" type="text/css" href="css/noJS.css" />
</noscript>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/component.js"></script>
<script type="text/javascript" src="js/componentStepper.js"></script>
</head><body>
<div id="page">
  <header id="header"><img src="images/logo.png" alt="Seneca College of Applied Arts and Technology" tabindex="1" title="Seneca College of Applied Arts and Technology"/>
    <nav>
      <ul>
        <li><a href="#" tabindex="4" title="Logout">Logout</a></li>
        <li class="divisor">|</li>
        <li><a href="settings.html" tabindex="3" title="User settings">Settings</a></li>
        <li class="divisor">|</li>
        <li><a href="#" tabindex="2" title="View user info">Ystallonne Alves</a></li>
      </ul>
    </nav>
  </header>
	<jsp:include page="menu.jsp"/>
  <section>
    <header>
      <p><a href="index.html" tabindex="13">home</a> » <a href="settings.html" tabindex="14">settings</a></p>
      <h1>Settings</h1>
    </header>
    <form>
      <article>
        <header>
          <h2>User Settings</h2>
          <img class="expandContent" src="images/arrowDown.png" title="Click here to collapse/expand content"/></header>
        <div class="content">
          <div class="component">
            <label for="nickname" class="label">Nickname:</label>
            <input type="text" name="nickname" id="nickname" class="input" tabindex="15" title="Nickname">
          </div>
          <div class="component">
            <label for="alternativeEmail" class="label">Alternative e-mail:</label>
            <input type="text" name="alternativeEmail" id="alternativeEmail" class="input" tabindex="16" title="Alternative e-mail">
          </div>
          <div class="component">
            <div class="checkbox" title="Automatically activate microphone"> <span class="box" role="checkbox" aria-checked="true" tabindex="17" aria-labelledby="setting1"></span>
              <label class="checkmark"></label>
              <label class="text" id="setting1">Automatically activate microphone.</label>
            </div>
          </div>
          <div class="component">
            <div class="checkbox" title="Automatically activate camera"> <span class="box" role="checkbox" aria-checked="true" tabindex="18" aria-labelledby="setting2"></span>
              <label class="checkmark"></label>
              <label class="text" id="setting2">Automatically activate camera.</label>
            </div>
          </div>
        </div>
      </article>
      <article>
        <header>
          <h2>Edit Password</h2>
          <img class="expandContent" src="images/arrowDown.png" title="Click here to collapse/expand content"/></header>
        <div class="content">
          <div class="component">
            <label for="currentPassword" class="label">Current password:</label>
            <input type="password" name="currentPassword" id="currentPassword" class="input" tabindex="19" title="Current password">
          </div>
          <div class="component">
            <label for="newPassword" class="label">New password:</label>
            <input type="password" name="newPassword" id="newPassword" class="input" tabindex="20" title="New password">
          </div>
          <div class="component">
            <label for="confirmPassword" class="label">Confirm password:</label>
            <input type="password" name="confirmPassword" id="confirmPassword" class="input" tabindex="21" title="Confirm password">
          </div>
        </div>
      </article>
      <article>
      <header>
        <h2>Default Meeting Settings</h2>
        <img class="expandContent" src="images/arrowDown.png" title="Click here to collapse/expand content"/></header>
      <div class="content">
      <div class="component">
        <div class="checkbox" title="Allow microphone sharing"> <span class="box" role="checkbox" aria-checked="true" tabindex="22" aria-labelledby="eventSetting1"></span>
          <label class="checkmark"></label>
          <label class="text" id="eventSetting1">Allow microphone sharing.</label>
        </div>
      </div>
      <div class="component">
        <div class="checkbox" title="Allow camera sharing"> <span class="box" role="checkbox" aria-checked="true" tabindex="23" aria-labelledby="eventSetting2"></span>
          <label class="checkmark"></label>
          <label class="text" id="eventSetting2">Allow camera sharing.</label>
        </div>
      </div>
      <div class="component">
        <div class="checkbox" title="Allow public whiteboard"> <span class="box" role="checkbox" aria-checked="true" tabindex="24" aria-labelledby="eventSetting3" ></span>
          <label class="checkmark"></label>
          <label class="text" id="eventSetting3">Allow public whiteboard.</label>
        </div>
      </div>
      <div class="component">
        <div class="checkbox" title="Allow event recording"> <span class="box" role="checkbox" aria-checked="true" tabindex="25" aria-labelledby="eventSetting4"></span>
          <label class="checkmark"></label>
          <label class="text" id="eventSetting4">Allow event recording.</label>
        </div>
      </div>
      </article>
      <p class="buttons">
        <input type="submit" name="submit" id="save" class="button" value="Save" title="Click here to save inserted data">
        <input type="button" name="button" id="cancel"  class="button" value="Cancel" title="Click here to cancel">
      </p>
    </form>
  </section>
  <footer>
    <nav id="footerMenu">
      <ul>
        <li><a href="index.html" title="Click here to go to the home page">Home</a></li>
        <li>|</li>
        <li><a href="contactUs.html" title="Click here to enter in contact with us">Contact Us</a></li>
        <li>|</li>
        <li><a href="help.html" title="Click here to obtain help information">Help</a></li>
      </ul>
    </nav>
    <div id="copyright">Copyright Â© 2013 - Seneca College of Applied Arts and Technology</div>
  </footer>
</div>
</body>
</html>