# Repeat output comming from other sources than default input (required for interaction with nvim-ipy)
c.ConsoleWidget.include_other_output = True

# Set style of console to solarizeddark
color_theme = 'Base16OceanDarkStyle'  # specify color theme

import pkg_resources
c.JupyterQtConsoleApp.stylesheet = pkg_resources.resource_filename(
    "jupyter_qtconsole_colorschemes", "{}.css".format(color_theme))

c.JupyterWidget.syntax_style = color_theme
