<template>
    <v-sheet min-height="70vh" rounded="lg">
        <center>
            <h2 class="pt-8">Restaurant Information</h2>
        </center>
        <div class="pa-8">
            <v-text-field v-model="restaurantID" label="Restaurant ID" outlined readonly></v-text-field>


            <v-text-field v-model="restaurantName" append-outer-icon="mdi-pencil" label="Restaurant Name" outlined
                @click:append-outer="editName = !editName" readonly></v-text-field>



            <v-text-field v-if="editName" v-model="updatedName" append-outer-icon="mdi-update"
                label="New Restaurant Name" @click:append-outer="updateName()"></v-text-field>

            <v-text-field v-model="tableNumber" append-outer-icon="mdi-pencil" label="Number of Tables" outlined
                @click:append-outer="editTable = !editTable" readonly></v-text-field>

            <v-text-field v-if="editTable" v-model="updatedTableNumber" append-outer-icon="mdi-update"
                label="New Table Number" type="number" @click:append-outer="updateTable()"></v-text-field>

            <v-snackbar v-model="snackbar">
                {{ text }}

                <template v-slot:action="{ attrs }">
                    <v-btn color="pink" text v-bind="attrs" @click="snackbar = false">
                        Close
                    </v-btn>
                </template>
            </v-snackbar>
        </div>
    </v-sheet>
</template>
<script>

export default {
    name: "InformationEdit",
    data() {
        return {
            title: 'Current Restaurant Name:',
            restaurantName: '',
            message4: 'Current Name',
            restaurantID: '',
            tableNumber: 0,
            updatedName: '',
            snackbar: false,
            text: '',
            editTable: false,
            editName: false,
            updateTableNumber: 0
        };
    },

    created() {
        this.getInformation();
    },
    methods: {
        async getInformation() {
            const res = await fetch(
                process.env.VUE_APP_BACKEND_URL + "admin/restaurantInfo",
                {
                    method: "GET",
                    credentials: 'include',
                }
            ,);
            let data = await res.json();
            console.log(data);
            this.restaurantID = data.restaurantID;
            this.updatedName = data.restaurantName;
            this.restaurantName = data.restaurantName;
            this.updatedTableNumber = data.tableNumber;
            this.tableNumber = data.tableNumber;
        },

        async updateName() {
            this.editName = false;
            if (this.snackbar) {
                this.snackbar = false;
            }
            if (!this.updatedName) {
                this.text = "Error - Invalid restaurant name";
                this.snackbar = true;
                return;
            } else if (this.restaurantName === this.updatedName) {
                this.text = "Error - Name same as the old name";
                this.snackbar = true;
                return;
            }
            const res = await fetch(process.env.VUE_APP_BACKEND_URL + "admin/restaurantName", {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                credentials: "include",
                body: JSON.stringify({
                    "restaurantName": this.updatedName
                })
            });
            const data = await res.json();
            console.log(data);
            if (data.status == 200) {
                this.restaurantName = this.updatedName;
                this.text = "Successfully updated restaurant name"
                this.snackbar = true;
            }
            else {
                alert("Error");
            }
        },
        async updateTable() {
            this.editTable = false;
            if (this.snackbar) {
                this.snackbar = false;
            }
            if (!this.updatedTableNumber) {
                this.updatedTableNumber = this.tableNumber;
                this.text = "Error - Invalid table number";
                this.snackbar = true;
                return;
            } else if (this.updatedTableNumber === this.tableNumber) {
                this.text = "Error - Table number same as the old table number";
                this.snackbar = true;
                return;
            } else if(this.updatedTableNumber < 0){
                this.text = "Error - Table number cannot be negative";
                this.snackbar = true;
                return;
            }
            this.updatedTableNumber = parseInt(this.updatedTableNumber);
            const res = await fetch(process.env.VUE_APP_BACKEND_URL + "admin/tables", {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                credentials: "include",
                body: JSON.stringify({
                    "tableNumber": this.updatedTableNumber
                })
            });
            const data = await res.json();
            console.log(data);
            if (data.status == 200) {
                this.tableNumber = this.updatedTableNumber;
                this.text = "Successfully updated number of tables"
                this.snackbar = true;
            }
            else {
                this.updatedTableNumber = this.tableNumber;
                this.text = "Error - Table Number must be a number";
                this.snackbar = true;
            }
        }
    }



}
</script>
