var webdriver = require("selenium-webdriver");

var driver = new webdriver.Builder().
        withCapabilities(webdriver.Capabilities.chrome()).
            build();


driver.get("http://localhost:3080/share");


driver.wait(5000);

driver.quit();
