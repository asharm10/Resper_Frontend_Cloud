<template>
    <v-app id="inspire">
        <v-app-bar color="error" class="flex-grow-0" app dark>
            <v-spacer />
            <v-toolbar-title class="nav-title">RESPER</v-toolbar-title>
            <v-spacer />
        </v-app-bar>

      <v-main class="grey lighten-3">

            <v-container>
                <v-row>
                    <v-col cols="12" sm="9">
                        <v-sheet min-height="70vh" rounded="lg">
                            <center>
                                <h2 class="pt-8">Requests</h2>
                            </center>
                        <template>
                          <v-row>
                            <v-col cols="auto">
                              <v-sheet class="py-4 px-1">
                                <v-chip-group mandatory selected-class="text-primary" color="#4db6ac">
                                  <v-chip v-for="tag in tags" :key="tag" @click="showRequests(tag)"> {{ tag }} </v-chip>
                                </v-chip-group>
                              </v-sheet>
                            </v-col>
                          </v-row>
                        </template>

                          <v-list three-line>
                                <template  v-for="(table, index) in this.requests" >
                                  <v-list-item :key="index" v-if="table.requests.length > 0">
                                    <v-list-item-content >
                                      <v-list-item-title v-html="joinRequests(table.requests)"></v-list-item-title>
                                      <v-list-item-subtitle v-html="'Table ' + table.table"></v-list-item-subtitle>
                                      <v-divider :key="index"></v-divider>
                                    </v-list-item-content>
                                  </v-list-item>
                              </template>
                            </v-list>
                        </v-sheet>
                    </v-col>

                    <v-col cols="12" sm="3">
                        <v-sheet rounded="lg" min-height="430">
                            <!-- first button -->
                            <div class="pa-2">
                                <center>
                                    Hi, <b>{{ fullname }}</b>!

                                </center>
                            </div>
                            <div class="pa-2">

                                <v-dialog v-model="dialog" width="500">
                                    <template v-slot:activator="{ on, attrs }">
                                        <v-btn color="teal lighten-2" dark block v-bind="attrs" v-on="on">
                                            Log Out
                                        </v-btn>
                                    </template>

                                    <v-card>
                                        <v-card-title class="text-h5 grey lighten-2">
                                            LOGOUT
                                        </v-card-title>

                                        <v-card-text>
                                            Are you sure you want to Logout?
                                        </v-card-text>

                                        <v-divider></v-divider>

                                        <v-card-actions>
                                            <v-spacer></v-spacer>
                                            <v-btn color="primary" text @click="logout">
                                                Yes
                                            </v-btn>
                                            <v-btn color="primary" text @click="dialog = false">
                                                No
                                            </v-btn>
                                        </v-card-actions>
                                    </v-card>
                                </v-dialog>
                            </div>
                            <!-- second button -->

                            <div class="pa-2">

                                <v-dialog v-model="dialog2" width="500">
                                    <template v-slot:activator="{ on, attrs }">
                                        <v-btn color="teal lighten-2" dark block v-bind="attrs" v-on="on">
                                            {{ checkIn }}
                                        </v-btn>
                                    </template>

                                    <v-card>
                                        <v-card-title class="text-h5 grey lighten-2">
                                            {{ checkIn }}
                                        </v-card-title>

                                        <v-card-text>
                                            {{ message }}
                                        </v-card-text>

                                        <v-divider></v-divider>

                                        <v-card-actions>
                                            <v-spacer></v-spacer>
                                            <v-btn color="primary" text @click="checkInorOut(checkIn)">
                                                Yes
                                            </v-btn>
                                            <v-btn color="primary" text @click="dialog2 = false">
                                                No
                                            </v-btn>
                                        </v-card-actions>
                                    </v-card>
                                </v-dialog>
                            </div>
                            <!-- third button-->
                            <div class="pa-2">

                                <v-dialog v-model="dialog4" width="500">
                                    <template v-slot:activator="{ on, attrs }">
                                        <v-btn color="teal lighten-2" dark block v-bind="attrs" v-on="on">
                                            Add Table
                                        </v-btn>
                                    </template>

                                    <v-card>
                                        <v-card-title class="text-h5 grey lighten-2">
                                            Add Table
                                        </v-card-title>

                                        <v-card-text mt-10>
                                            Type the Table number:
                                        </v-card-text>
                                      <v-responsive
                                          class="mx-auto"
                                          max-width="344"
                                      >
                                        <v-text-field
                                            :rules="[rules.required]"
                                            clearable
                                            label="Table Number"
                                            v-model ="assignTable"
                                        ></v-text-field>
                                      </v-responsive>
                                        <v-divider></v-divider>

                                        <v-card-actions>
                                            <v-spacer></v-spacer>
                                            <v-btn color="primary" text @click="dialog4 = false; addTable()">
                                                Add Tables
                                            </v-btn>
                                            <v-btn color="primary" text @click="dialog4 = false">
                                                Close
                                            </v-btn>
                                        </v-card-actions>
                                    </v-card>
                                </v-dialog>
                            </div>

                          <div >
                            <v-list rounded>
                              <v-subheader>Tables Assigned</v-subheader>
                              <v-list-item-group color="primary">
                                <v-list-item v-for="(item, i) in tablesAssignedArray" :key="i" >
                                  <v-list-item-content @click="dialog5 = true; openTableDialog=item; displayTableInfo(item)" >
                                      <v-list-item-title v-text="'Table '+item"></v-list-item-title>
                                  </v-list-item-content>
                                  <v-list-item-action>

                                    <v-icon color="grey lighten-1" @click="removeTables(item)">
                                      mdi-delete-outline
                                    </v-icon>

                                  </v-list-item-action>
                                </v-list-item>
                              </v-list-item-group>
                            </v-list >

                            <v-dialog v-model="dialog5" width="600px">
                              <v-card>
                                <v-card-text>
                                  <v-data-table :headers="headers" :items="tableInfo" :items-per-page="5">
                                    <template #item="{ item,  }">
                                      <tr>
                                        <td v-for="(value, key) in item" :key="key">
                                          <div v-if="key != '_id'">{{ value }}</div>
                                        </td>
                                        <td>
                                          <v-btn
                                              class="ma-2"
                                              color="primary"
                                              @click="completeRequest(item)"
                                          >
                                            Done
                                            <v-icon
                                                end
                                                icon="mdi-checkbox-marked-circle"
                                            ></v-icon>
                                          </v-btn>
                                        </td>
                                      </tr>
                                    </template>
                                  </v-data-table>
                                </v-card-text>
                                <v-card-actions>
                                  <v-btn color="primary" block @click="dialog5 = false; openTableDialog = null;">Close Dialog</v-btn>
                                </v-card-actions>
                              </v-card>
                            </v-dialog>
                          </div>
                        </v-sheet>
                    </v-col>
                </v-row>
                <v-snackbar v-model="snackbar">
                    {{ snackbarText }}

                    <template v-slot:action="{ attrs }">
                        <v-btn color="pink" text v-bind="attrs" @click="snackbar = false">
                            Close
                        </v-btn>
                    </template>
                </v-snackbar>
            </v-container>
        </v-main>
    </v-app>
</template>

<script setup>
export default {

    name: "ServerPage",
    data() {
        return {
            dialog: false,
            dialog2: false,
            dialog3: false,
            dialog4: false,
            dialog5 : false,
            checkIn: this.checkIn,
            message: this.message,
            token: this.token,
            snackbar: false,
            snackbarText: '',
            username: '',
            fullname: '',
            tablesAssignedArray: [],
            tables: this.tables,
            assignTable: this.assignTable,
            tableInfo : [],
            requests: {},
            openTableDialog: null,
            tags: ['All Requests', 'My Requests'],
            curReq : 'All Requests',
            headers : [
              { text: 'Requests', align: 'start', value: 'request' },
              { text: 'Time', align: 'center', value: 'time' },
              { text: 'Completed', align: 'end', },

            ],
            rules: {
            required: value => !!value || 'Field is required',
      },

        };
    },
    async created() {
        this.token = localStorage.getItem('token')
        this.username = localStorage.getItem('username');
        this.fullname = localStorage.getItem('fullname');
        // console.log(this.token);
        if (!localStorage.getItem("checkIn")) {
            this.checkIn = "Check In"
            this.message = "Do you want to check in?"
            localStorage.setItem('checkIn', this.checkIn)
        }
        else {
            this.checkIn = localStorage.getItem("checkIn")
            if (this.checkIn === "Check In") {
                this.message = "Do you want to check in?"
            }
            else if (this.checkIn === "Check Out") {
                this.message = "Do you want to check out?"
            }
        }

        this.showRequests(this.curReq);
        this.getTablesAssignedArray();

      const res = await fetch(
          process.env.VUE_APP_BACKEND_URL +this.$route.params.id+"/server/tables",
          {
            method: "GET",
            credentials: 'include',
          }
          ,);
      let data = await res.json();
      this.tables = data.tables
    }


    ,
    methods: {
        logout(e) {
            e.preventDefault();
            if (localStorage.getItem('token')) {
                localStorage.removeItem('token');
            }
            if (localStorage.getItem('username')) {
                localStorage.removeItem('username');
            }
            if (localStorage.getItem('fullname')) {
                localStorage.removeItem('fullname');
            }
            this.dialog = false;
            this.$store.dispatch("setServerToken", 403);
            this.$router.back();
        },
        async checkInorOut(checkIn) {
            const { token } = this
            // console.log(this.$route.params.id)
            let isCheckedIn = "checkout";
            if (checkIn === "Check In"){isCheckedIn = "checkin"}
            const res = await fetch(process.env.VUE_APP_BACKEND_URL + this.$route.params.id + "/server/" + isCheckedIn, {
              method: "POST",
              headers: {
                "Content-Type": "application/json"
              },
              credentials: "include",
              body: JSON.stringify({
                token,
              })
            });
            const data = await res.json();

            if (checkIn === "Check In") {
                if (data.success || data.status === 404) {
                    this.checkIn = "Check Out"
                    this.message = "Do you want to check out?"
                    localStorage.setItem('checkIn', this.checkIn)
                    if (data.success) {
                        this.snackbarText = "Checked in Successfully"
                    }
                    else if (data.status === 404) {
                        this.snackbarText = "Already Checked In"
                    }
                    this.snackbar = true
                }
                else {
                    this.snackbarText = "Error checking in"
                    this.snackbar = true;
                }


            }
            else if (checkIn === "Check Out") {
                if (data.status === 200 || data.status === 404) {
                    this.checkIn = "Check In"
                    this.message = "Do you want to check in?"
                    localStorage.setItem('checkIn', this.checkIn)
                    if (data.status === 200) {
                        this.snackbarText = "Checked out Successfully"
                    }
                    else if (data.status === 404) {
                        this.snackbarText = "You are not checked In"
                    }
                }
                else {
                    this.snackbarText = "Error checking out"
                }
                this.snackbar = true;

            }
            this.dialog2 = false;

        },

      async addTable(){
        if ( parseInt(this.assignTable) < 1 || parseInt(this.assignTable) > this.tables){
            this.snackbarText = "Table not available"
        }
        else if ( (this.tablesAssignedArray).includes(parseInt(this.assignTable)) ){
            this.snackbarText = "Table already Assigned"
        }
        else{
            const { token, assignTable, username } = this
            const res = await fetch(
              process.env.VUE_APP_BACKEND_URL +this.$route.params.id+"/server/tables", {
                method: "POST",
                headers: {
                  "Content-Type": "application/json"
                },
                credentials: "include",
                body: JSON.stringify({token, assignTable, username})
              });
            const data = await res.json();
            // console.log(data);
            if (data.status === 200){
              await this.getTablesAssignedArray();
              await this.showRequests(this.curReq);
              this.snackbarText = "Table Assigned Successfully"
            }
            else{this.snackbarText = "Unsuccessful"}
        }
        this.snackbar =true;
        this.assignTable = '';
      },

      async removeTables(table){
        const { token } = this
        const res = await fetch(
            process.env.VUE_APP_BACKEND_URL+ this.$route.params.id+"/server/tables",
            {
              method: "PUT",
              credentials: 'include',

              headers: {
                "Content-Type": "application/json"
              },
              body: JSON.stringify({table, token})
            }
            ,);
        const data = await res.json();
        if (data.status === 200) {
          console.log("success")
          await this.getTablesAssignedArray();
          await this.showRequests(this.curReq);
          this.snackbarText = "Assigned table deleted"
        } else {
          this.snackbarText = "Unsuccessful"
        }
      },

      async getTablesAssignedArray(){
        const res = await fetch(
            process.env.VUE_APP_BACKEND_URL+this.$route.params.id+"/server/"+this.username,
            {
              method: "GET",
              credentials: 'include',
            }
            ,);
        const data = await res.json();
        if (data.status === 200){
          this.tablesAssignedArray = data.success;
        }
      },

      displayTableInfo(){
        this.tableInfo= []
        for (const request of this.requests){
          if (request.table == this.openTableDialog){
            this.tableInfo = request.requests;
          }
        }
        // console.log(this.tableInfo)
      },


      async getAllRequests() {
        const res = await fetch(
            process.env.VUE_APP_BACKEND_URL+this.$route.params.id+"/server/requests",
            {
              method: "GET",
              credentials: 'include',
            }
            ,);
        const data = await res.json();
        this.requests = data.success;
      },


      async getServerRequests(){
        const res = await fetch(
            process.env.VUE_APP_BACKEND_URL+this.$route.params.id+"/server/serverRequests/"+this.username,
            {
              method: "GET",
              credentials: 'include',
            }
            ,);
        const data = await res.json();
        this.requests = data.success;
      },

      joinRequests(requests) {
        return requests.map(request => request.request).join(", ");
      },

      async showRequests(tag){
        if (tag === 'All Requests'){
          await this.getAllRequests();
        }
        else if (tag === 'My Requests'){
          await this.getServerRequests();
        }
        else{console.log(this.curReq, ' ERROR ->', tag)}
        this.curReq = tag;
      },

      async completeRequest(request){
        console.log(request);
        // const { token } = this
        const { username } = this
        const res = await fetch(
            process.env.VUE_APP_BACKEND_URL+ this.$route.params.id+"/server/requests",
            {
              method: "PUT",
              credentials: 'include',

              headers: {
                "Content-Type": "application/json"
              },
              body: JSON.stringify({ request, username })
            }
            ,);
        const data = await res.json();
        if (data.status === 200){
          await this.showRequests(this.curReq)
          await this.displayTableInfo();
        }else{
          this.snackbarText = "Couldn't mark the requesst complete"
        }

      },

    },


};

</script>
