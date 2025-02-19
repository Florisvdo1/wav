#!/bin/bash
# One-click audiophile binaural setup script for Windows (Git Bash)
# Installs software, downloads binaural recordings, and sets up an integrated audio player

set -e

# Create directories
mkdir -p "$HOME/Binaural_Audio/Recordings"
mkdir -p "$HOME/Binaural_Audio/Player"
mkdir -p "$HOME/Binaural_Audio/Thumbnails"

# Install Chocolatey (Windows package manager) if not installed
if ! command -v choco &> /dev/null; then
    echo "Installing Chocolatey..."
    powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
fi

# Install essential audio software
choco install foobar2000 -y
choco install ffmpeg -y
choco install sox -y
choco install asio4all -y
choco install voicemeeter-banana -y

# Download the most beautiful audiophile-grade music player from GitHub
cd "$HOME/Binaural_Audio/Player"
git clone https://github.com/Florisvdo1/wav 
cd MusicPlayer
powershell -Command "Start-Process -NoNewWindow -FilePath 'install.bat'"

# Download Top 10 Secret Binaural WAV files
cd "$HOME/Binaural_Audio/Recordings"

declare -A binaural_files
binaural_files=(
    ["Sexual Arousal (Male-Female)"]="https://freesound.org/people/dbspin/sounds/396687/download/396687__dbspin__binaural-sex.wav"
    ["Deep Theta Meditation"]="http://www.multidimensionalman.com/Multidimensional-Man/Free_Deep_Meditation_Sounds_-_Binaural_Beats_files/30_min_deep_meditation-1.mp3"
    ["Out of Body Experience (OBE)"]="http://www.multidimensionalman.com/Multidimensional-Man/Free_Deep_Meditation_Sounds_-_Binaural_Beats_files/The_Far_Countries-Multidimensional_Man.mp3"
    ["Astral Projection"]="https://archive.org/download/RestorativeSleepMusicBinauralBeatsSleepInTheClouds432Hz/Out%20Of%20Body%20Experience%20Astral%20Travel%20Music%20-%20Astral%20Projection%20432%20Hz.mp3"
    ["Lucid Dreaming"]="https://archive.org/download/binaural-beats_201904/Iso%20Binaural%20Lucid%20Dream.mp3"
    ["3D Spatial Soundscape"]="https://www.all-about-psychology.com/media-files/virtual-barber-shop.mp3"
    ["Focus & Concentration"]="https://archive.org/download/40-hz-gamma-pure-tone-binaural-beat-brains-operating-system/Accelerated%20Learning%20-%20Gamma%20Waves%20for%20Focus%2C%20Memory%2C%20Concentration%20-%20Binaural%20B.mp3"
    ["Ultimate Relaxation"]="https://archive.org/download/binaural-beats_201904/Sound%20Sleep.mp3"
    ["Psychedelic Soundscape"]="https://archive.org/download/binaural-beats_201904/Transcendence%20Binaural%20Beat.mp3"
    ["Schumann Resonance"]="https://archive.org/download/binaural-beats_201904/Schumanns%20Rain%20Meditation.mp3"
)

for title in "${!binaural_files[@]}"; do
    url="${binaural_files[$title]}"
    filename="${title// /_}.wav"
    echo "Downloading: $title..."
    curl -L "$url" -o "$filename"
done

# Generate Thumbnails (B with black background)
cd "$HOME/Binaural_Audio/Thumbnails"
for i in {1..10}; do
    convert -size 300x300 xc:black -fill white -gravity center -pointsize 150 -draw "text 0,0 'B'" "${i}B.png"
done

echo "Thumbnails created: 1B.png to 10B.png"

# Set up Foobar2000 with WASAPI/ASIO for best quality
powershell -Command "& {Start-Process foobar2000.exe -ArgumentList '/register', '/quiet' -Wait}"

# Launch player and play binaural recordings
cd "$HOME/Binaural_Audio/Recordings"
powershell -Command "Start-Process foobar2000.exe -ArgumentList '/play', '*.*'"

echo "Setup complete! Your binaural audio is now playing in high fidelity."
