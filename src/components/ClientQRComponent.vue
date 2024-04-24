<template>
    <v-sheet min-height="80vh" rounded="lg">
        <center>
            <h3 class="px-10 pt-10">Client Page URL</h3>
            <br />
          <div class="d-inline-flex flex-column justify-center">
            <v-autocomplete
                clearable
                label="Table Number"
                :items="this.tableArray"
                v-model="table"
            ></v-autocomplete>
            <v-btn @click="getQRCode()">
              Generate QR Code
            </v-btn>
          </div>
          <div v-if="qrCode" class="pa-15">
            <img alt="QR CODE" v-bind:src="qrCode" />
            <p>{{ qrCode.substring(62) }}</p>
            <v-btn color="error" @click="openQRLink()">DOWNLOAD</v-btn>
          </div>
        </center>
    </v-sheet>
</template>
<script>
export default {
    name: "ClientQRComponent",
    data() {
        return {
            qrCode: '',
            table: '',
            tableArray: [],
            restaurantID: '',
        };
    }, created() {
        this.restaurantID = localStorage.getItem('restaurantID');
        this.getTables();
    },
    methods: {

        openQRLink() {
            window.open(this.qrCode, '_blank');
        },

        async getQRCode() {

            if (!this.restaurantID) {
                return;
            }
            else if(!this.table){return alert("Choose a Table");}
            // else if(this.table < 1 || this.table > this.totalTables){
            //   alert("Invalid ")
            // }
            // this.qrCode = "https://api.qrserver.com/v1/create-qr-code/?size=400x400&data=http://localhost:8080/" + restaurantID +"/client/";
          this.qrCode = "https://api.qrserver.com/v1/create-qr-code/?size=400x400&data=http://localhost:8080/" + this.restaurantID +"/client/"+this.table;

        },

        async getTables(){
           if (!this.restaurantID){return;}

          const res = await fetch(
              process.env.VUE_APP_BACKEND_URL+this.restaurantID+"/server/tables",
              {
                method: "GET",
                credentials: 'include',
              }
              ,);
          const data = await res.json();
          if (data.status === 200) {
            for (let index = 1; index <= data.tables; index++) {
              this.tableArray.push(index);
            }
          }
            else{
              alert("error")
            }
            console.log(this.tableArray, (data));
        },

    }
}
</script>
