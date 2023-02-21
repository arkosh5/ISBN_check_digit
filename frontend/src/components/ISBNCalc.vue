<template>
  <div class="container">
    <div class="form-group">
      <label for="isbn">Enter ISBN-13 Barcode:</label>
      <div class="input-group">
        <input type="text" id="isbn" class="input-box" v-model="state.isbn" :disabled="state.scanning">
        <button class="button-calculate" @click="calculateCheckDigit">Calculate</button>
      </div>
      <div class="input-group" v-if="!state.scanning">
        <button class="button-calculate" @click="scanBarcode">Scan Barcode</button>
      </div>
      <div class="input-group" v-else>
        <p>Scanning barcode...</p>
      </div>
    </div>

    <div class="alert-result" v-if="state.result !== null && !state.error">
      <span>Result:</span>
      <div class="result-box">{{ state.completeIsbn }}</div>
      <button class="button-copy" @click="copyToClipboard(state.completeIsbn)">Copy</button>
    </div>

    <div class="alert-error" v-if="state.error">
      <span class="result-box">Invalid ISBN-13</span>
    </div>
  </div>
  <div class="modal" v-if="state.error">
    <div class="modal-content">
      <p>{{ state.error }}</p>
      <button @click="dismissError">OK</button>
    </div>
  </div>
</template>


<script>
import Quagga from 'quagga';
import {computed, nextTick, reactive} from 'vue';
export default {
  name: 'ISBNCalc',
  setup() {
    const state = reactive({
      isbn: '',
      checkDigit: null,
      completeIsbn: null,
      result: null,
      scanning: false,
      error: '',
    });

    const isValidISBN = computed(() => {
      return state.isbn && /^\d{12}$/.test(state.isbn);
    });

    const calculateCheckDigit = async () => {
      state.error = '';
      try {
        const response = await fetch(`/calculate_isbn13_check_digit/${state.isbn}`);
        const text = await response.text();
        try {
          const result = JSON.parse(text);
          if (result.error) {
            state.error = result.error;
          } else {
            state.checkDigit = result.check_digit;
          }
        } catch (err) {
          state.error = `Error parsing server response: ${err.message}`;
        }
      } catch (err) {
        state.error = `Error communicating with server: ${err.message}`;
      }

      const numericIsbn = state.isbn.replace(/\D/g, ''); // Remove non-numeric characters
      const numericCheckDigit = state.checkDigit ? state.checkDigit.toString().replace(/\D/g, '') : '';
      state.completeIsbn = numericIsbn + numericCheckDigit;
      state.result = isValidISBN.value;
    };

    const scanBarcode = async () => {
      state.scanning = true;
      await nextTick();
      Quagga.init({
        inputStream: {
          name: 'Live',
          type: 'LiveStream',
          target: document.querySelector('#isbn'),
          constraints: {
            width: 640,
            height: 480,
            facingMode: 'environment',
          },
        },
        decoder: {
          readers: ['ean_reader'],
        },
      }, (err) => {
        if (err) {
          console.error(err);
          return;
        }
        Quagga.start();
      });
      Quagga.onDetected((result) => {
        state.isbn = result.codeResult.code.slice(0, 12);
        Quagga.stop();
        state.scanning = false;
        calculateCheckDigit();
      });
    };

    const copyToClipboard = (text) => {
      navigator.clipboard.writeText(text);
    };
    const dismissError = () => {
      state.error = '';
    };

    return {
      state,
      calculateCheckDigit,
      scanBarcode,
      copyToClipboard,
      dismissError,
    };
  },
};



</script>
<style src="./ISBNCalc.css"></style>