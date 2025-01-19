# Audio Engine A2+ Speakers Configuration

## Configuration

$XDG_CONFIG_HOME/ladspa_dsp/config
$HOME/.config/ladspa_dsp/config (if $XDG_CONFIG_HOME is not set)
/etc/ladspa_dsp/config

## Commands
```bash
git clone https://github.com/bmc0/dsp.git
cd dsp
./configure --disable-dsp --disable-fftw3 --disable-zita-convolver
make
sudo make install

./scripts/rew_to_dsp.sh AudioEngine_A2_Plus.txt

# Effects Chain Output Load into $XDG_CONFIG_HOME/ladspa_dsp/config
# eq 180 1.00 -6.0 eq 1073 1.45 2.5 eq 1590 2.00 -1.5 eq 2731 1.33 -5.6 eq 3781 1.00 4.5 eq 4763 6.00 -1.2 eq 7686 2.00 -2.5 eq 14221 1.00 -3.9 eq 24 2.00 -15.0 eq 32 3.00 -15.0 eq 39 4.00 -10.0 eq 75 2.00 5.0 eq 110 3.00 -2.2

pulseaudio --start

pacmd list-sinks
# sink_name:alsa_output.usb-Audioengine_LLC_Audioengine_2__AE202010001A2002-00.analog-stereo

pacmd load-module module-ladspa-sink sink_name=dsp sink_master=alsa_output.usb-Audioengine_LLC_Audioengine_2__AE202010001A2002-00.analog-stereo plugin=ladspa_dsp label=ladspa_dsp

```


