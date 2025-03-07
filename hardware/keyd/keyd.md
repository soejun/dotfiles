This is to remap our keyboard in Sway (Since there is no good solution that's easy)

[Github: keyd](https://github.com/rvaiya/keyd)

```bash
git clone https://github.com/rvaiya/keyd
cd keyd
make && sudo make install
sudo systemctl enable --now keyd
```

## Quickstart
1.Install and start keyd (e.g sudo systemctl enable keyd --now)
2. Put the following in `/etc/keyd/default.conf`:
3. Run `sudo keyd reload` to reload the config set.
4. See the man page (`man keyd`) for a more comprehensive description.

To get key names, run:
```bash
sudo keyd monitor
```

*Note: It is possible to render your machine unusable with a bad config file. 
Should you find yourself in this position, the special key sequence 
`backspace+escape+enter` should cause keyd to terminate.*
