local eq = assert.are.same

describe('config parsing', function()
  local config_module = require 'lualine.config'

  describe('options', function()
    describe('icons_enabled', function()
      it('default', function()
        local config = config_module.apply_configuration({})
        eq(config.options.icons_enabled, true)
      end)
      it('custom', function()
        local config = {options = {icons_enabled = false}}
        config = config_module.apply_configuration(config)
        eq(config.options.icons_enabled, false)
      end)
    end)

    describe('theme', function()
      it('default', function()
        local config = config_module.apply_configuration({})
        eq(config.options.theme, 'gruvbox')
      end)
      it('custom', function()
        local config = {options = {theme = 'nord'}}
        config = config_module.apply_configuration(config)
        eq(config.options.theme, 'nord')
        config = {options = {theme = {}}}
        config = config_module.apply_configuration(config)
        eq(config.options.theme, {})
      end)
    end)

    describe('separators', function()
      it('default', function()
        local config = config_module.apply_configuration({})
        eq(config.options.component_separators, {'', ''})
        eq(config.options.section_separators, {'', ''})
      end)
      it('double separators', function()
        local config = {
          options = {
            component_separators = {'a', 'b'},
            section_separators = {'c', 'd'}
          }
        }
        config = config_module.apply_configuration(config)
        eq(config.options.component_separators, {'a', 'b'})
        eq(config.options.section_separators, {'c', 'd'})
      end)

      describe('single separator', function()
        it('string', function()
          local config = {
            options = {component_separators = 'a', section_separators = 'b'}
          }
          config = config_module.apply_configuration(config)
          eq(config.options.component_separators, {'a', 'a'})
          eq(config.options.section_separators, {'b', 'b'})
        end)
        it('table', function()
          local config = {
            options = {component_separators = {'a'}, section_separators = {'b'}}
          }
          config = config_module.apply_configuration(config)
          eq(config.options.component_separators, {'a', 'a'})
          eq(config.options.section_separators, {'b', 'b'})
        end)
      end)
      it('no seprarators', function()
        local config = {
          options = {component_separators = {}, section_separators = {}}
        }
        config = config_module.apply_configuration(config)
        eq(config.options.component_separators, {})
        eq(config.options.section_separators, {})
      end)
    end)

    describe('disabled filetypes', function()
      it('default', function()
        local config = config_module.apply_configuration({})
        eq(config.options.disabled_filetypes, {})
      end)
      it('custom', function()
        local config = {options = {disabled_filetypes = {'lua'}}}
        config = config_module.apply_configuration(config)
        eq(config.options.disabled_filetypes, {'lua'})
      end)
    end)

    describe('non default global option', function()
      it('default', function()
        local config = {options = {}}
        config = config_module.apply_configuration(config)
        eq(config.options.non_default_global_option, nil)
      end)
      it('custom', function()
        local config = {options = {non_default_global_option = 1}}
        config = config_module.apply_configuration(config)
        eq(config.options.non_default_global_option, 1)
      end)
    end)
  end)

  describe('sections', function()
    it('default', function()
      local config = {}
      config = config_module.apply_configuration(config)
      local lualine_default_sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      }
      eq(config.sections, lualine_default_sections)
    end)
    it('custom', function()
      local custom_sections = {
        lualine_a = {{'mode', lower = true}},
        lualine_b = {'branch', {'branch', lower = true}},
        lualine_c = nil,
        lualine_x = {}
      }
      local expected_sections = {
        lualine_a = {{'mode', lower = true}},
        lualine_b = {'branch', {'branch', lower = true}},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      }
      local config = {sections = custom_sections}
      config = config_module.apply_configuration(config)
      eq(config.sections, expected_sections)
    end)
  end)

  describe('inactive_sections', function() end)

  describe('tabline', function()
    it('default', function()
      local config = {}
      config = config_module.apply_configuration(config)
      eq(config.tabline, {})
    end)
    it('custom', function()
      local custom_sections = {
        lualine_a = {{'mode', lower = true}},
        lualine_b = {'branch', {'branch', lower = true}},
        lualine_c = nil,
        lualine_x = {}
      }
      local expected_sections = {
        lualine_a = {{'mode', lower = true}},
        lualine_b = {'branch', {'branch', lower = true}},
        lualine_x = {}
      }
      local config = {tabline = custom_sections}
      config = config_module.apply_configuration(config)
      eq(config.tabline, expected_sections)
    end)
  end)

  describe('extensions', function()
    it('default', function()
      local config = {options = {}}
      config = config_module.apply_configuration(config)
      eq(config.extensions, {})
    end)
    it('custom', function()
      local config = {extensions = {'fugitive'}}
      config = config_module.apply_configuration(config)
      eq(config.extensions, {'fugitive'})
    end)
  end)
end)
