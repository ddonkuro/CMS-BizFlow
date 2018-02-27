/* global _ angular $ CMS_REPORT_FILTER */
(function () {
    'use strict';

    angular.module('bizflow.app').component('reportFilter', {
        templateUrl: function ($element, $attrs, bizflowContext) {
            var template = 'features/reportFilter/report-filter.html';
            return template;
        },
        controller: Ctrl
    });

    function Ctrl ($scope, blockUI, bizflowContext, $log, $window, $filter, $location) {
        var vm = this;

        // Attributes
        vm.group = {};
        vm.components = ['By Admin Code', 'Office of the Administrator (OA) Only'];
        vm.includeSubOrgs = ['Yes', 'No'];
        vm.requestTypes = ['All', 'Appointment', 'Classification Only', 'Recruitment'];
        vm.allClassificationTypes = ['All', 'Audit Position', 'Conduct 5-year Recertification','Create New Position Description', 'Reorganization for Existing Position',
                                    'Reorganization for New Position', 'Review Existing Position Description','Update Coversheet', 'Update Major Duties'];
        vm.recruitmentClassificationTypes = ['All', 'Conduct 5-year Recertification','Create New Position Description', 'Review Existing Position Description',
                                'Reorganization for New Position','Update Coversheet', 'Update Major Duties'];                                
        vm.appointmentTypes = ['All', '30% or more disabled veterans', 'Expert/Consultant', 'Schedule A', 'Veteran Recruitment Appointment (VRA)', 'Volunteer'];
        vm.scheduleATypes = ['All', 'CMS Fellows-Paid (R)', 'Digital Services', 'Disability (U)', 'Innovator-In-Residence', 'Interpreters (LL)', 'WRP (Summer Hire)'];
        vm.volunteerTypes = ['All', 'CMS Fellows-Unpaid', 'Student Volunteer', 'Wounded Warriors', 'Youth Works'];
        vm.reportNameDescriptionMap = [
            {'name': 'Time of Possession - Classification Only Report', 'description': 'This report calculates the number of days each request resides with HR vs Component users in NEIL for Classification Only request types. It includes the number of days spent in Strategic Consultation and Classification, and produces an average number of days the request resides in HR and the average number of days the request resides with the Component.'},
            {'name': 'Time to Consult Report', 'description': 'This report lists the number of days it takes for each request to proceed from start to end in Strategic Consultation.  It includes requests from all three request types - Classification Only, Recruitment, and Appointment.'},
            {'name': 'Time to Classify Report', 'description': 'This report lists the number of days it takes for each request to proceed from start to end in Classification.  It includes requests from all three request types - Classification Only, Recruitment, and Appointment.'},
            {'name': 'Time to Appoint Report', 'description': 'This report lists the number of days it takes to complete eligibility and qualification reviews for appointment only requests (i.e. Schedule A, 30% or more disabled veteran and veteran recruitment adjustment (VRA)). It only includes Appointment request types.'},
        ];
        vm.reportDescription = 'This report lists the number of days it takes for each request.';
        vm.orgSelected = {
            component: '',
            adminCode: '',
            includeSubOrg: 'Yes',
            requestType: 'All',
            classificationType: 'All',
            appointmentType: 'All',
            scheduleAType: 'All',
            volunteerType: 'All',
            fromDate: null,
            toDate: null,
            selectingOfficial: {grpname: '', grpid: '', memberid: 'All', name: 'All'},
            executiveOfficer: {grpname: '', grpid: '', memberid: 'All', name: 'All'},
            hrLiaison: {grpname: '', grpid: '', memberid: 'All', name: 'All'},
            staffSpecialist: {grpname: '', grpid: '', memberid: 'All', name: 'All'},
            classSpecialist: {grpname: '', grpid: '', memberid: 'All', name: 'All'}
        };
        vm.selected = {};
        vm.fromDateOpened = false;
        vm.toDateOpened = false;
        vm.dateOptionFrom = {
            showWeeks: false,
            maxDate: new Date()
        };
        vm.dateOptionTo = {
            showWeeks: false,
            maxDate: new Date()
        };
        vm.onSelect = function ($item, $mode, $select) {
            $select.focusserTitle = $item.name;
        }

        // Functions
        vm.getClassificationTypes = function () {
            var types = [];
            if (vm.selected.requestType === 'All' || vm.selected.requestType === 'Classification Only') {
                types = types.concat(vm.allClassificationTypes);
            } else if (vm.selected.requestType === 'Recruitment') {
                types = types.concat(vm.recruitmentClassificationTypes);
            } else if (vm.selected.requestType === 'Appointment') {
                types = types.concat(vm.recruitmentClassificationTypes, ['Reorganization for Existing Position']);
            } else {
                types = [];
            }

            types.sort();
            return types;
        };

        vm.adjustBizCoveUI = function () {
            try {
                $('#mainWrapper table.tableTab', window.parent.document).remove(); // Remove BizCove Header
                $('#mainWrapper table.list td', window.parent.document).css({'padding': '0px 0px 0px 0px'}); // Adjust padding
                $('#modalPopupMax0Title', window.parent.parent.document).text(CMS_REPORT_FILTER.REPORTNAME); // Set report name
            } catch (e) {
                $log.error(e);
            }
        };

        vm.initUserGroups = function () {
            var groups = JSON.parse(CMS_REPORT_FILTER.GROUPS).groups;
            vm.group = _.groupBy(groups, 'grpname');
            for (var prop in vm.group) {
                if (vm.group.hasOwnProperty(prop)) {
                    vm.group[prop].unshift({grpname: '', grpid: '', memberid: '', name: 'All'});
                }
            }
            var amIDCOManagerLeads = _.filter(vm.group['DCO Managers and Leads'], function (item) {
                return item.memberid === CMS_REPORT_FILTER.CURUSERID;
            });
            var amIAdminTeam = _.filter(vm.group['Admin Team'], function (item) {
                return item.memberid === CMS_REPORT_FILTER.CURUSERID;
            });
            if (amIDCOManagerLeads.length > 0 || amIAdminTeam.length > 0) {
                vm.components = ['By Admin Code', 'CMS-wide', 'Office of the Administrator (OA) Only'];
            }
        };

        // Calendar functions & configuration
        vm.changeFromOption = function () {
            vm.dateOptionTo.minDate = vm.selected.fromDate ? vm.selected.fromDate : null;
        };
        vm.changeToOption = function () {
            vm.dateOptionFrom.maxDate = vm.selected.toDate ? vm.selected.toDate : new Date();
        };
        vm.openFromDate = function ($event) {
            $event.preventDefault();
            $event.stopPropagation();
            vm.toDateOpened = false;
            vm.fromDateOpened = true;
        }
        vm.openToDate = function ($event) {
            $event.preventDefault();
            $event.stopPropagation();
            vm.toDateOpened = true;
            vm.fromDateOpened = false;
        }

        vm.getDateString = function (when) {
            var month = when.getMonth() + 1;
            month = month < 10 ? ('0' + month) : month;
            var day = when.getDate();
            day = day < 10 ? ('0' + day) : day;
            var year = when.getFullYear();

            var dateString = year + '-' + month + '-' + day;
            return dateString;
        };

        vm.getTargetReportURL = function () {
            var url = '/bizflowadvreport/flow.html?_flowId=viewReportFlow&decorate=no';
            url = url + '&j_memberid=' + CMS_REPORT_FILTER.CURUSERID; // j_memberid
            url = url + '&j_username=' + CMS_REPORT_FILTER.CURLOGINID; // j_username
            url = url + '&reportUnit=' + CMS_REPORT_FILTER.REPORTPATH; // reportUnit
            if (vm.selected.component.length > 0) { // Component
                url = url + '&COMPONENT=' + vm.selected.component;
            }
            if (vm.selected.adminCode.length > 0) { // Admin Code
                url = url + '&ADMIN_CD=' + vm.selected.adminCode.toUpperCase();
            } else {
                url = url + '&ADMIN_CD=~NULL~';
            }
            if (vm.selected.fromDate != null) { // COMP_DATE_FROM
                var from = vm.getDateString(vm.selected.fromDate);
                url = url + '&COMP_DATE_FROM=' + from;
            } else {
                url = url + '&COMP_DATE_FROM=2000-01-01';
            }
            if (vm.selected.toDate != null) { // COMP_DATE_TO
                var to = vm.getDateString(vm.selected.toDate);
                url = url + '&COMP_DATE_TO=' + to;
            } else {
                url = url + '&COMP_DATE_TO=2050-12-31';
            }
            url = url + '&REQ_TYPE=' + vm.selected.requestType; // Request Type
            url = url + '&CLSF_TYPE=' + vm.selected.classificationType; // Classification Type
            url = url + '&APPT_TYPE=' + vm.selected.appointmentType; // Appointment Type
            url = url + '&SCHDA_TYPE=' + vm.selected.scheduleAType; // Schedula A Type
            url = url + '&VOL_TYPE=' + vm.selected.volunteerType; // Volunteer Type
            url = url + '&SO_ID=' + vm.selected.selectingOfficial.memberid; // Selecting Official
            url = url + '&XO_ID=' + vm.selected.executiveOfficer.memberid; // Executive Officer
            url = url + '&HRL_ID=' + vm.selected.hrLiaison.memberid; // HR Liaison
            url = url + '&SS_ID=' + vm.selected.staffSpecialist.memberid; // Staff specialist
            url = url + '&CS_ID=' + vm.selected.classSpecialist.memberid; // Class specialist
            //$log.debug('Report URL [' + url + ']');
            return url;
        };

        vm.submit = function () {
            if (vm.selected.component !== 'By Admin Code') {
                vm.selected.adminCode = '';
                vm.selected.includeSubOrg = '';
            }
            if (vm.selected.appointmentType === 'Expert/Consultant' || vm.selected.appointmentType === 'Volunteer') {
                vm.selected.classificationType = 'All';
            }
            if (vm.selected.requestType !== 'Appointment') {
                vm.selected.appointmentType = 'All';
            }
            if (vm.selected.appointmentType !== 'Schedule A') {
                vm.selected.scheduleAType = 'All';
            }
            if (vm.selected.appointmentType !== 'Volunteer') {
                vm.selected.volunteerType = 'All';
            }
            var url = vm.getTargetReportURL();

            window.open(url, '_blank');
            setTimeout(function () {
                vm.close();
            }, 0);
        };

        vm.reset = function () {
            vm.selected = _.assign({}, vm.orgSelected);
        };

        vm.close = function () {
            try {
                $('#modalPopupMax0CloseButton', window.parent.parent.document).click();
            } catch (e) {
                $log.info('Cancel button is clicked but failed to dismiss BizCove. ' + e);
            }
        }

        // {
        //     "requestType": {
        //         "setList" : ["Appointment"]
        //     },
        //     "appointmentType": {
        //         "addList": {
        //             "position": 0,
        //             "list": ["All"]
        //         },
        //         "setDefault" : "All"
        //     }
        // }
        // setList, addList cannot be combined.
        vm.applyOption = function (targetObject, attributeName, selectAttributeName, optionItem) {
            if (optionItem.setList) {
                targetObject[attributeName] = optionItem.setList;
                if (optionItem.setList.length === 1) {
                    targetObject.orgSelected[selectAttributeName] = optionItem.setList[0];
                }
                return;
            }

            if (optionItem.addList && typeof optionItem.addList.position === 'number' && optionItem.addList.list && optionItem.addList.list.length > 0) {
                var targetArray = targetObject[attributeName];
                var position = optionItem.addList.position;
                var list = optionItem.addList.list;
                targetObject[attributeName] = targetArray.slice(0, position).concat(list).concat(targetArray.slice(position));
            }

            if (optionItem.setDefault) {
                targetObject.orgSelected[selectAttributeName] = optionItem.setDefault;
            }
        };

        vm.initDescription = function () {
            if (CMS_REPORT_FILTER.REPORTNAME && CMS_REPORT_FILTER.REPORTNAME.length > 0) {
                var foundReportMap = _.find(vm.reportNameDescriptionMap, function(item) {
                    if (item.name === CMS_REPORT_FILTER.REPORTNAME) {
                        return true;
                    } else {
                        return false;
                    }
                });

                if (foundReportMap) {
                    vm.reportDescription = foundReportMap.description;
                } else {
                    $log.info('No report found from report map. [' + CMS_REPORT_FILTER.REPORTNAME + ']');
                }
            }
        };

        vm.initOption = function () {
            if (CMS_REPORT_FILTER.OPTION && CMS_REPORT_FILTER.OPTION.length > 0) {
                var option = {};
                try {
                    option = JSON.parse(CMS_REPORT_FILTER.OPTION);
                } catch (e) {
                    $log.error('Failed to parse OPTION - ' + e);
                }

                if (option.requestType) {
                    vm.applyOption(vm, 'requestTypes', 'requestType', option.requestType);
                }
                if (option.appointmentType) {
                    vm.applyOption(vm, 'appointmentTypes', 'appointmentType', option.appointmentType);
                }
            }
        }

        vm.$onInit = function () {
            $log.info('reportFilter $onInit');
            vm.adjustBizCoveUI();
            vm.initUserGroups();
            vm.initDescription();
            vm.initOption();
            vm.selected = _.assign({}, vm.orgSelected);
            $('#reportFilter').attr('aria-busy', 'false');
        };

        vm.$onDestroy = function () {
            $log.info('reportFilter $onDestroy');
        };
    }
})();





