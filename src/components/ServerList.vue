<template>
    <v-sheet min-height="70vh" rounded="lg">
        <center>
            <h2 class="pt-8">Servers</h2>
        </center>
        <v-toolbar elevation="0">
            <v-text-field v-model="search" label="Search a server"></v-text-field>
        </v-toolbar>
        <v-list two-line>
            <v-list-item-group v-model="selected">
                <template v-for="(item, index) in filteredItems">
                    <v-list-item :key="item.username">
                        <template>

                            <v-list-item-content v-bind="attrs" v-on="on"
                                @click="showDialog(item.username, item.fullname, item.weeklyHours, item.hoursWorked, item.password)">
                                <v-list-item-title v-text="item.fullname"></v-list-item-title>
                                <v-list-item-subtitle class="text--primary" v-text="item.username">
                                </v-list-item-subtitle>
                            </v-list-item-content>
                            <v-list-item-action>

                                <v-icon color="grey lighten-1" @click="remove(item.username)">
                                    mdi-delete-outline
                                </v-icon>

                            </v-list-item-action>
                        </template>
                    </v-list-item>

                    <v-divider v-if="index < servers.length - 1" :key="index"></v-divider>
                </template>
            </v-list-item-group>
        </v-list>
        <v-dialog v-model="dialog2" width="500">
            <v-card>
                <v-card-title class="text-h5 grey lighten-2">
                    Server Information
                </v-card-title>

                <v-card-text class="pt-5">
                    <v-text-field name="Full Name" :value="dialogFullname" label="Full Name" readonly></v-text-field>
                    <v-text-field name="Username" :value="dialogUsername" label="Username" readonly></v-text-field>
                    <v-text-field name="Weekly Hours" :value="dialogWeeklyHours" label="Hours This Week" readonly></v-text-field>
                    <v-text-field name="dialogPassword" :value="dialogPassword" label="Password"
                        :append-icon="dialogPasswordValue ? 'mdi-eye-off' : 'mdi-eye'"
                        @click:append="() => (dialogPasswordValue = !dialogPasswordValue)"
                        :type="dialogPasswordValue ? 'password' : 'text'" readonly></v-text-field>

                    <v-data-table :headers="headers" :items="dialogHours" :items-per-page="5">

                    </v-data-table>
                </v-card-text>

                <v-divider></v-divider>

                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="primary" text @click="dialog2 = false">
                        Close
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-sheet>
</template>
<script>
export default {
    name: "ServerList",
    data() {
        return {
            dialog2: false,
            dialogUsername: '',
            dialogFullname: '',
            dialogPassword: '',
            dialogHours: [],
            dialogPasswordValue: true,
            dialogWeeklyHours: 10,
            servers: [],
            searchItem: [],
            search: '',
            headers: [
                {
                    text: 'Date',
                    value: 'date',
                    align: 'start'
                },
                {
                    text: 'Hours',
                    value: 'numHours'
                }
            ]
        };
    },
    async created() {
        this.$root.$refs.ServerList = this;
        await this.getServers();
    },
    computed: {
        filteredItems() {
            return this.searchItem.filter((item) => {
                return item.username.toLowerCase().match(this.search.toLowerCase()) ||
                    item.fullname.toLowerCase().match(this.search.toLowerCase())
            })
        }
    },
    methods: {
        showDialog(username, fullname, weeklyHours, hours, password) {
            this.dialogUsername = username;
            this.dialogFullname = fullname;
            this.dialogWeeklyHours = weeklyHours;
            this.dialogHours = hours;
            this.dialogPassword = password;
            console.log(hours);
            this.dialog2 = true;
        },
        async getServers() {
            const res = await fetch(
                process.env.VUE_APP_BACKEND_URL + "admin/servers",
                {
                    method: "GET",
                    credentials: 'include',
                }
            ,);
            let data = await res.json();
            // data=data.success;
            console.log(data);
            this.servers = data.success;
            setTimeout(() => this.searchItem = this.servers)
        },

        async remove(username) {

            const res = await fetch(
                process.env.VUE_APP_BACKEND_URL + "admin/servers",
                {
                    method: "DELETE",
                    credentials: 'include',

                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({
                        username
                    })
                }
            ,);
            const data = await res.json();
            if (data.status === 200) {
                await this.getServers();
            } else {
                alert("Could not delete the server!")
            }
        },
    }
}
</script>