// Turns frames into GIF or WebP pieces away from the page, so several frames are worked on at
// once while the page gets the next ones ready. The page puts the pieces together in order.
self.window = self; // gifenc.js puts itself on window
importScripts('gifenc.js');

self.onmessage = async ({ data: job }) => {
  try {
    if (job.format === 'gif') {
      const { GIFEncoder, quantize, applyPalette } = self.gifenc;
      const rgba = new Uint8ClampedArray(job.pixels);
      const palette = quantize(rgba, job.colours, { format: 'rgb565' });
      const gif = GIFEncoder({ auto: false });
      // The first frame also carries the screen size, its palette as the main one, and "loop forever".
      gif.writeFrame(applyPalette(rgba, palette, 'rgb565'), job.w, job.h, { palette, delay: job.ms, repeat: 0, first: job.index === 0 });
      const bytes = gif.bytes();
      self.postMessage({ id: job.id, bytes }, [bytes.buffer]);
    } else {
      const canvas = new OffscreenCanvas(job.w, job.h);
      canvas.getContext('2d').drawImage(job.bitmap, 0, 0);
      job.bitmap.close();
      const blob = await canvas.convertToBlob({ type: 'image/webp', quality: job.quality });
      if (blob.type !== 'image/webp') throw new Error('nowebp');
      const bytes = new Uint8Array(await blob.arrayBuffer());
      self.postMessage({ id: job.id, bytes }, [bytes.buffer]);
    }
  } catch (e) {
    self.postMessage({ id: job.id, error: e.message || String(e) });
  }
};
