{ config, pkgs, ... }:

{
	system.activationScripts.create_vimrc =
	{
		text = ''
			mkdir -p /home/vicente/.config/nvim/lua
			cp ${./lua/init.lua}     /home/vicente/.config/nvim/init.lua
			cp ${./lua/options.lua}  /home/vicente/.config/nvim/lua/options.lua
			cp ${./lua/plugins.lua}  /home/vicente/.config/nvim/lua/plugins.lua
			cp ${./lua/keymaps.lua}  /home/vicente/.config/nvim/lua/keymaps.lua
			cp ${./lua/ui.lua}       /home/vicente/.config/nvim/lua/ui.lua
			chmod -R 0644 /home/vicente/.config/nvim
		'';
	};

	# Create a service since i need ssh to be online
	systemd.services.install-vim-plugins =
	{
		description = "Install Vim plugins after SSH is ready";
		wantedBy = [ "default.target" ];
		after = [ "network-online.target" ];
		wants = [ "network-online.target" ];
		serviceConfig =
		{
			Type = "oneshot";
			User = "vicente";
			ExecStart = "${pkgs.neovim}/bin/nvim --headless \"+Lazy! sync\" +qa";
		};
	};
}
