<img src="web/icon.png" width="96" alt="">

# Library Cover Maker

Make animated cover art for your Jellyfin and Emby libraries, and animated or still posters for your films and series on Jellyfin, Emby and Plex.

Add up to 6 videos or pictures, or pick a whole folder and let it choose 6 at random. Type the library name and it builds an animated WebP or GIF, or a still PNG, that cuts between moments from each file, with a rounded white frame and the name in a big serif font. Switch to **Poster** for a portrait poster in the same style. Choose the moment for each video yourself, or leave it random. Pictures get a slow zoom.

Use files from the computer you're on, from your media folders on the server, or straight from your Jellyfin or Emby server: pick a film and it cuts moments from the film itself. It can also make a poster for every film and series, or a cover for every library, in one go, and put the original pictures back whenever you like.

The covers are made in your browser. Nothing is sent anywhere unless you use **Send to your server**, which sends it to your own Jellyfin, Emby or Plex server.

## Install

### Unraid

Search for **Library Cover Maker** in Community Applications, or add the template from [p1zzm1ssile/unraid-templates](https://github.com/p1zzm1ssile/unraid-templates).

To use **Send to your server**, edit the container, click **Add another Path, Port, Variable, Label or Device**, choose **Variable**, and add one with the key `JELLYFIN_URL` and your Jellyfin address as the value, such as `http://192.168.1.10:8096`. Do the same with `EMBY_URL` for Emby or `PLEX_URL` for Plex.

To be able to put the original pictures back, and to make posters or covers for everything at once, also add a **Path** with the container path `/data` and a host path such as `/mnt/user/appdata/library-cover-maker`.

### Docker Compose

```yaml
services:
  library-cover-maker:
    image: ghcr.io/p1zzm1ssile/library-cover-maker:latest
    container_name: library-cover-maker
    ports:
      - "8097:8097"
    volumes:
      - /path/to/media:/media:ro
      # Optional: keeps the original pictures so you can put them back
      - /path/to/appdata/library-cover-maker:/data
    environment:
      # Optional: your server addresses, for Send to your server
      - JELLYFIN_URL=http://192.168.1.10:8096
      # - EMBY_URL=http://192.168.1.11:8096
      # - PLEX_URL=http://192.168.1.10:32400
    restart: unless-stopped
```

### Docker

```sh
docker run -d --name library-cover-maker -p 8097:8097 -v /path/to/media:/media:ro -v /path/to/appdata/library-cover-maker:/data -e JELLYFIN_URL=http://192.168.1.10:8096 --restart unless-stopped ghcr.io/p1zzm1ssile/library-cover-maker:latest
```

Then open `http://<your-server-ip>:8097` in Edge, Chrome or Firefox. Safari can't make WebP images, but it can make GIFs.

Jellyfin uses port 8096, so the default here is 8097. To use another port, change the first number (`8097:8097` → `9000:8097`).

`JELLYFIN_URL`, `EMBY_URL` and `PLEX_URL` are all optional. Set any of them to the address you use to open that server, and the page can send covers and posters straight to it (see [Send to your server](#send-to-your-server)). If the server runs in Docker on the same network as this container, its container name works too, such as `http://jellyfin:8096`. Leave them out and everything else works the same.

`/data` is optional too. The page keeps each title's or library's own picture there before replacing it, along with a list of what it has made. Without it you can still send covers and posters, but **Put back** and the make-everything buttons are turned off. Use a folder this container can write to.

Map your media folder to `/media`, read-only. You can map several folders under it, such as `/media/movies` and `/media/tv`. They appear under the **Server media** button. Leave it out if you only want to use files from your computer.

The fonts load from Google Fonts, so the computer you open the page on needs internet access. Without it the text falls back to Georgia.

## Make a cover

1. Drop in up to 6 videos (MP4 works best) or pictures, or click **Pick a folder** to have 6 chosen at random from a folder on your computer. **Server media** browses the folders mapped to `/media`: click a file to add it, or **Use this folder** for 6 random files from that folder and its subfolders. **New random files** picks a different 6, and with **New random files each time I click Make** ticked, every cover uses a fresh set.
   **Videos only when picking from a folder** is ticked by default, so posters and other pictures in your media folders are skipped.
2. Each video in the list has its own slider and a small preview of the frame. Drag the slider to choose the moment that video's clip starts at. Click **Random** to go back to a random moment.
3. Pick or type the library name and drag the preview to position the picture. Then set the look:
   - **Font**: Bodoni Moda, Playfair Display, Cinzel, Cormorant Garamond, Abril Fatface, Bebas Neue, Anton, Oswald, Montserrat or Lobster.
   - **Text size**, from 50% to 200% of the size that fits the name, and **Text position** at the top, middle or bottom.
   - **A shadow under the text** and **Darken the picture behind the text**, each on or off, and the rounded white frame.
4. Set **How long each moment plays** (0.5 to 3 seconds), and choose WebP, GIF or still PNG. **Fade between moments** fades through black from one to the next, and **Fade out at the end, and in at the start** makes the loop start again from black; **How long each fade takes** is 0.2 to 1 second.
5. Click **Make animated cover**, then **Download animated cover**.

Keep the file under about 5 MB so your home screen loads quickly. Shorter moments make smaller files. The page shows the size of each file it makes.

**File size settings** has more ways to make files smaller: the picture size, frames a second, and for GIFs the number of colours. It also sets how many moments are cut when the pictures come from your server (1 to 6).

## Make a poster

Click **Poster** at the top of the right-hand panel. It works the same way, but makes a portrait 2:3 poster with the title at the bottom (or wherever you set **Text position**), split over up to 3 lines if it's long. Your library cover's name and text position are kept for when you switch back.

## WebP, GIF or PNG?

- **WebP** is smaller and looks better. It's animated in the Jellyfin web page, but the Jellyfin apps (Android TV, phones, and so on) show it as a still picture, because Jellyfin resizes every picture it sends to them.
- **GIF** is the one picture type Jellyfin sends untouched, so a GIF **stays animated in the apps too**. Emby's web page sends GIFs untouched as well, so pick GIF for Emby. GIFs are made a bit smaller by default (480×270 for covers, 240×360 for posters, 10 frames a second) to keep the file size sensible.
- **Still PNG** is a single picture in the same style, taken from the first file in the list at its chosen moment. Use it for Plex, which turns every poster into a still picture anyway, or anywhere you don't want movement.

## Send to your server

With `JELLYFIN_URL`, `EMBY_URL` or `PLEX_URL` set, the page has a **Send to your server** section under the preview. If you set more than one, pick the server at the top of the section.

1. Get a key for the server:
   - **Jellyfin**: **Dashboard → API Keys**, click **+**, and give it a name like `Cover Maker`.
   - **Emby**: in the server settings, open **API Keys** and add one.
   - **Plex**: open any film's **⋯ → Get Info → View XML** and copy the `X-Plex-Token` value from the end of the address.
2. Paste it into the page and click **Connect**. It's saved in your browser only.
3. For a library cover: choose the library. Its name is filled in for you. Make the cover, then click **Send cover to this library**. It becomes the library's main image, so there's no CSS to add.
4. For a poster: switch to **Poster**, search for the film or series, or click **Pick one at random**, and click it. Its title is filled in. Make the poster, then click **Send poster to this title**.

The page talks to your server through the container, so you don't need to change any server settings.

If the page says it can't reach a server, check that its address is the one you'd type in a browser, including `http://` and the port, then restart the container.

### Moments from the film itself

On Jellyfin and Emby you don't need files of your own:

- **Use its video**, under a film or series, cuts moments from that film, or from a few random episodes of a series.
- **Use videos from this library**, under the library, cuts moments from a few random things in it.

Moments are spread through the video, so you get a mix rather than the opening titles. If your browser can play the file it's used as it is. If not (HEVC, HDR and some other files), the server converts just those few seconds for the page. Click **Make** again for different random moments.

Some things can't be used, and the page says why: streams (`.strm` files and other remote links, since cutting moments opens several connections to the provider at once), disc folders, and titles with no media file.

### Put back the original

With `/data` mapped, the page saves each title's or library's own picture before replacing it. **Put back its own poster** and **Put back its own picture** appear once something has been sent, and return it to how it was. The picture made here is replaced, including the copy your server saves next to your media if it's set to save artwork into media folders.

If a title had no picture of its own, or the copy kept for it is animated (an earlier version could keep a poster it had made as the original if the page was reloaded mid-send), Put back removes the picture made here and asks your server to fetch the title's own artwork again.

### Posters for every film and series, or a cover for every library

> [!CAUTION]
> **Animated posters for your whole library are not recommended on Fire TV sticks, smart TVs and other low-end devices.** They have a small processor and little memory, and a screen full of animated posters can make them slow, stutter or crash. Animated library covers are fine, as there are only a few of them. For posters on every film and series, choose Still PNG, or try a few animated ones by hand on your slowest device first. The page shows this warning too.

With `/data` mapped and a Jellyfin or Emby server connected, open **Posters for every film and series** under the send section (or **Covers for every library** in Cover mode).

1. Untick any libraries you want left out. The page remembers that for next time.
2. It shows how many there are, how many it's already made, and roughly how much space the rest will take, once you've made one to measure.
3. **Make the missing ones** makes and sends one for each title it hasn't done before, using the look and file settings on the page. Titles with a poster you've changed by hand since are left alone. **Make them all again** remakes every one with new random moments.
4. While it works it shows which one it's on and, once one is made, roughly how much time is left. **Stop** stops after the current one. Anything that couldn't be made is listed with the reason.
5. **Put back all the originals** returns every title or library it has changed.

It runs in your browser. If the page is reloaded or closed, it carries on from where it got to the next time you open the page, with the same settings. It doesn't run on a timer by itself.

### Plex

Plex works for posters, using a still PNG. Plex has no pictures for libraries, so library covers can't be sent there, and **Use its video** and the make-everything buttons are for Jellyfin and Emby only.

## Use it in Jellyfin by hand

If you'd rather not use Send to your server, or want the cover to only animate when you hover over it:

1. In Jellyfin, right-click the library on the home screen → **Edit images** → upload the file with type **Logo**.
2. Find the library's ID: open the library and copy the `topParentId` value from the address bar.
3. Add this to **Dashboard → General → Custom CSS code**, with your ID in both places:

```css
.card[data-id="YOUR_LIBRARY_ID"] .cardImageContainer {
  background-image: url("/Items/YOUR_LIBRARY_ID/Images/Logo") !important;
}
```

For an animation that only plays when you hover over the card, use `.card[data-id="YOUR_LIBRARY_ID"]:hover .cardImageContainer` as the first line instead.

Add one block per library, then press Ctrl+F5.

Leave `maxWidth` and `quality` off the image address: if Jellyfin resizes the image, it can lose its animation.

## Build it yourself

```sh
docker build -t library-cover-maker .
docker run -d -p 8097:8097 -v /path/to/media:/media:ro -v /path/to/data:/data library-cover-maker
```

Or open `web/index.html` straight in your browser. It works without a server, but Send to your server needs the container.
